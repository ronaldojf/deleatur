require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :json

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  ensure_security_headers # See more: https://github.com/twitter/secureheaders

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

  private

  def key_for_controller_session
    namespace = self.class.to_s.deconstantize
    "#{namespace}#{controller_name}"
  end
end
