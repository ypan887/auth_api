class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  prepend_before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    permitted_parameters = devise_parameter_sanitizer.instance_values['permitted']
    permitted_parameters[:sign_up] << :name
    permitted_parameters[:sign_up] << :nickname
  end
end
