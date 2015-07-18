JsRoutes.setup do |config|
  config.prefix = ENV["RAILS_RELATIVE_URL_ROOT"] if ENV["RAILS_RELATIVE_URL_ROOT"]
  config.compact = true
  config.camel_case = true
end