module NgTableHelper
  # Another way to set custom values on ng_table scope
  def ng_table_custom_values(values = {})
    @ng_table_custom_values = values
  end

  class ActiveRecord::Base
    def with_ng_table(custom_values = {})
      values = custom_values
        .merge(@ng_table_custom_values || {})
        .merge(params || {})

      self
        .page(values[:page])
        .per(values[:count])

      if values[:sorting].try(:keys).try(:any?)
        self.order(values[:sorting].inject({}) { |r, k|  r[k.first] = k.second.to_sym; r })
      end

      self
    end
  end
end