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