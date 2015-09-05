class Admin::BaseController < ApplicationController
  include IndexTableFilters
  before_action :authenticate_administrator!

  layout 'authenticated'
  helper_method :current_user

  def current_user
    current_administrator
  end
end
