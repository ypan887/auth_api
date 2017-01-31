# Introduction

The purpose of the project is to explore the best practice on how to implement user authentication with Restful Api.

User authentication is the basic feature for many web application. This api aimed to implement both token based authentication and OAuth authentication.

## Adding session and cookie middleware only for Oauth
This stateless api use devise-auth-token and Omniauth gem under the hood to help with Oauth authetication. Session and Cookie middleware is used by Omniauth to persist information between the api and auth provider's server.

## Consume Authenticate Api Server with React

The api exposed several endpoints to support token based authentication and OAuth authentication. Any client side solution should be able to utilize these endpoints for authentication. I have built an React and Redux app on the client side that uses this api for authentication. If you want to see how I implement login/sign up feature on React, please visit [here](https://github.com/ypan887/React_Auth_App).

## Override default behavior 

Although Devise-Auth-token take cares most of the authentication logic by default, I need to override some of its default behavior in order to work with the client side app properly. You can find how to override default controller action in Devise-Auth-token on their github docs.

### Override Oauth Authentication
By default, Devise-Auth-token render success Oauth callback in json. However, my client side solution was deployed on a different domain with no server side counter part to handle JSON response. So, I need to override the default behavior. The new controller take in the client app's address, and execute a short JS code which post token back to client app on success callback from Oauth provider

```
module Overrides
  class OmniauthCallbacksController <   DeviseTokenAuth::OmniauthCallbacksController

    def redirect_callbacks
      ENV['ORIGIN'] = params['auth_origin_url']
      super
    end

    def auth_origin_url
      ENV['ORIGIN'] || omniauth_params['auth_origin_url'] || omniauth_params['origin']
    end

    def render_data_or_redirect(message, data, user_data = {})
      if ['inAppBrowser', 'newWindow'].include?(omniauth_window_type)
        render_data(message, user_data.merge(data))
      elsif auth_origin_url
        data["user_name"]= user_data["name"] || user_data["nickname"] 
        render :html => "<script>window.opener.postMessage(#{data.to_json}, '#{auth_origin_url}');window.close();</script>".html_safe, :layout => false
      else
        fallback_render 'An error occurred'
      end
    end
  end
end
```

### Override Session Controller
This is not really a session controller. Instead of creating session for user it generates token for authenticated user instead. However, the default behavior does not return client_id and auth_token in response. So here is my override.

```
module Overrides
  class SessionsController < DeviseTokenAuth::SessionsController
    
  protected
    def render_create_success
      response_data = @resource.as_json(except: [
          :created_at, :updated_at
        ]
      )
      response_data["client_id"] = @client_id
      response_data["auth_token"] = @resource.tokens[@client_id]["token"]
      render json: {
        data: response_data
      }
    end
  end
end
```

## Using the Api
Here are some important endpoints in this Api

### Email sign up

```
curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://0.0.0.0:3000/auth -d "{\"email\":\"user@example.com\",\"password\":\"secretpassword\"}"
```

### Email sign in
```
curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://0.0.0.0:3000/auth/sign_in -d "{\"email\":\"user@example.com\",\"password\":\"secretpassword\"}"
```

### Get protected resoureces/ validate token
If you do not implement a session controller to store user session on server, you would need to include your user credentials in the header of each subsequent requests while visiting guarded resources. The credentials that you need to include in your header are access-token, client, and uid. If you simply want to validate your token, you get GET the /auth/validate_token endpoint

To validate token:
```
curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'access-token:p9SQ416At27TKDJcm0up9g' -H 'client:cfGjGmGYdloxgW-YrNEzsQ' -H 'uid:user@example.com' GET http://0.0.0.0:3000/auth/validate_token
```


To visit protected source:
```
curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'access-token:p9SQ416At27TKDJcm0up9g' -H 'client:cfGjGmGYdloxgW-YrNEzsQ' -H 'uid:user@example.com' GET http://0.0.0.0:3000/api/v1/users
```