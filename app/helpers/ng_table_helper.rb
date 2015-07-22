module NgTableHelper
  def scope_for_ng_table(model)
    result = model
      .page(params[:page])
      .per(params[:count])

    if params[:sorting].try(:keys).try(:any?)
      result = result.order(params[:sorting].collect { |k,v|  [k.to_s, v.to_s].join(" ") })
    end

    store_params_on_session(params)
    result
  end

  private

  def store_params_on_session(params)
    store_controller_config :sorting, params[:sorting]
    store_controller_config :page, params[:page]
    store_controller_config :count, params[:count]
    store_controller_config :filter, params[:filter]
  end
end