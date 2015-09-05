class Student::BaseController < ApplicationController
  include IndexTableFilters
  before_action :authenticate_student!

  layout 'authenticated'
  helper_method :current_user

  def current_user
    current_student
  end
end