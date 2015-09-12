require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :json

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  ensure_security_headers # See more: https://github.com/twitter/secureheaders

  before_action :configure_permitted_parameters, if: :devise_controller?

  def store_controller_config(name, value)
    session[key_for_controller_session] ||= {}
    session[key_for_controller_session][name.to_s] = value
  end

  def get_controller_config(name)
    session[key_for_controller_session].try(:[], name.to_s)
  end

  def clear_controller_config
    session.delete key_for_controller_session
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation, :gender, :cpf, :phone, :birth_date, :status, :classroom_id)
    end
  end

  private

  def key_for_controller_session
    namespace = self.class.to_s.deconstantize
    "#{namespace}#{controller_name}"
  end
end
