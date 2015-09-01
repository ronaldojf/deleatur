module Utils::Filtering
  extend ActiveSupport::Concern
  CLEAR_VALUE_OPTIONS = {
    simple_clear: /[\-|\s|\.|\(|\)]/
  }

  included do
    def self.filtering(*attributes)
      options = attributes.last.is_a?(Hash) ? attributes.last : {}
      attributes = attributes[0..attributes.size-2] if options.present?
      main_query = attributes.join(' ILIKE :text OR ') + ' ILIKE :text'
      cleared_query = options.collect { |k,v| v.join(" ILIKE :#{k} OR ") + " ILIKE :#{k}" }.join(' ')

      scope :filter, -> (text) {
        if text.present?
          cleared_values = {}
          CLEAR_VALUE_OPTIONS.each { |k,v| cleared_values[k] = "%#{text.gsub(v, '')}%" }

          query_array = []
          query_array << main_query if main_query.present?
          query_array << cleared_query if cleared_query.present?

          where(query_array.join(' OR '), {text: "%#{text}%"}.merge(cleared_values))
        end
      }
    end
  end
end