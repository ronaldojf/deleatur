class Teacher::BaseController < ApplicationController
  include IndexTableFilters
  before_action :authenticate_teacher!

  layout 'authenticated'
  helper_method :current_user

  def current_user
    current_teacher
  end
end