class Student::BaseController < ApplicationController
  include IndexTableFilters
  before_action :authenticate_student!
  before_action :set_user_pontuation

  layout 'authenticated'
  helper_method :current_user

  def current_user
    current_student
  end

  def set_user_pontuation
    @user_pontuation = current_user.pontuations.sum(:points)
  end
end