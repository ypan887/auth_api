module Overrides
  class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController

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