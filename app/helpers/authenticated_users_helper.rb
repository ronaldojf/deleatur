module AuthenticatedUsersHelper
  include NgTableHelper

  private

  def filters
    params[:filters] ||= {}

    if params[:clear]
      clear_controller_config
    else
      store_controller_config :page, params[:page] if params[:page].present?
      store_controller_config :sorting, params[:sorting] if params[:sorting].present?
      store_controller_config :filters, params[:filters] if params[:filters].present?
    end

    @page = get_controller_config(:page) || 1
    @sorting = get_controller_config(:sorting) || {}
    @filters = get_controller_config(:filters) || {general: ""}.to_json_with_active_support_encoder

    ng_table_custom_values({
      page: @page,
      sorting: @sorting
    })
  end
end