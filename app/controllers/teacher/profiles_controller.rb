class Teacher::ProfilesController < Teacher::BaseController

  def update
    current_user.update(teacher_params)
    respond_with current_user, location: -> { teacher_root_path }
  end

  private

  def teacher_params
    params[:teacher].except!(:password, :current_password, :password_confirmation) if params[:teacher][:password].blank?

    params
      .require(:teacher)
      .permit(:name, :gender, :status, :cpf, :phone, :birth_date,
              :email, :password, :current_password, :password_confirmation)
      .merge({validate_current_password: true})
  end
end