module NgTableHelper
  def scope_for_ng_table(model)
    result = model
      .page(params[:page])
      .per(params[:count])

    not_store_on_session = params[:session_store].try(:[], :sorting) == "false"

    if params[:sorting].try(:keys).try(:any?)
      store_controller_config :sorting, params[:sorting] unless not_store_on_session
      result = result.order(params[:sorting].collect { |k,v|  [k.to_s, v.to_s].join(" ") })
    end

    unless not_store_on_session
      store_controller_config :page, params[:page]
      store_controller_config :count, params[:count]
      store_controller_config :filter, params[:filter]
    end

    result
  end
end