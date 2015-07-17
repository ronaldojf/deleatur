class Admin::AdministratorsController < Admin::BaseController
  before_action :set_administrator, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @administrators = scope_for_ng_table(Administrator)
                            .filter(params[:filter].try(:[], 'general'))
      end
    end
  end

  def new
    @administrator = Administrator.new
  end

  def edit
    redirect_to(@administrator, alert: I18n.t('flash.actions.edit.alerts.editing_main_administrator')) if @administrator.main
  end

  def create
    @administrator = Administrator.new(administrator_params)
    @administrator.save
    respond_with @administrator
  end

  def update
    @administrator.update(administrator_params)
    respond_with @administrator
  end

  def destroy
    if current_user.main
      if @administrator.main
        redirect_to @administrator, alert: I18n.t('flash.actions.destroy.alerts.main_administrator')
      else
        @administrator.destroy
        respond_with @administrator, location: -> { administrators_path }
      end
    end
  end

  private

  def set_administrator
    @administrator = Administrator.find(params[:id])
  end

  def administrator_params
    params[:administrator].except!(:password, :password_confirmation) if params[:administrator][:password].blank?

    params
      .require(:administrator)
      .permit(:name, :email, :password, :password_confirmation)
  end
end