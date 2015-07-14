class Admin::AdministratorsController < Admin::BaseController
  before_action :set_administrator, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @administrators = Administrator
                            .with_ng_table
                            .filter(@filters[:general])
      end
    end
  end

  def new
    @administrator = Administrator.new
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
    if @administrator.main_administrator
      redirect_to @administrator, alert: I18n.t('flash.actions.destroy.alerts.main_administrator')
    elsif @administrator.id == current_user.id
      redirect_to @administrator, alert: I18n.t('flash.actions.destroy.alerts.self_destroy')
    else
      @administrator.destroy
      respond_with @administrator#, location: -> { administrators_path }
    end
  end

  private

  def set_administrator
    @administrator = Administrator.find(params[:id])
  end

  def administrator_params
    params
      .require(:administrator)
      .permit(:name, :email, :password, :password_confirmation)
  end
end