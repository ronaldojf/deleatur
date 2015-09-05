class Student::ProfilesController < Student::BaseController

  def update
    current_user.update(student_params)
    respond_with current_user, location: -> { student_root_path }
  end

  private

  def student_params
    params[:student].except!(:password, :current_password, :password_confirmation) if params[:student][:password].blank?

    params
      .require(:student)
      .permit(:name, :email, :password, :current_password, :password_confirmation)
      .merge({validate_current_password: true})
  end
end