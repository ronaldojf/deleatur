class Admin::ProfilesController < Admin::BaseController

  def update
    current_user.update(administrator_params)
    respond_with current_user, location: -> { admin_root_path }
  end

  private

  def administrator_params
    params[:administrator].except!(:password, :current_password, :password_confirmation) if params[:administrator][:password].blank?

    params
      .require(:administrator)
      .permit(:name, :email, :password, :current_password, :password_confirmation)
      .merge({validate_current_password: true})
  end
end