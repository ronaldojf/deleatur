module NgTableHelper
  def scope_for_ng_table(model)
    result = model
      .page(params[:page])
      .per(params[:count])

    if params[:sorting].try(:keys).try(:any?)
      result = result.order(params[:sorting].inject({}) { |r, k|  r[k.first] = k.second.to_sym; r })
    end

    result
  end
end