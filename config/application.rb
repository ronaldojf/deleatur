require File.expand_path('../boot', __FILE__)

require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

require File.expand_path('../../lib/base', __FILE__)
Bundler.require(*Rails.groups)

module Deleatur
  class Application < Rails::Application
    config.generators do |g|
      g.helper false
      g.view_specs false
      g.assets false
      g.integration_tool false
      g.controller_specs false
      g.mailer_specs false
      g.routing_specs false
      g.scaffold_controller :scaffold_controller
    end
    config.app_generators do |g|
      g.test_framework :rspec
    end

    config.assets.initialize_on_precompile = true

    config.time_zone = ENV.fetch('TZ', 'Brasilia')

    config.i18n.enforce_available_locales = true
    config.i18n.available_locales = ['pt-BR']
    config.i18n.locale = 'pt-BR'
    config.i18n.default_locale = 'pt-BR'

    config.middleware.use Rack::Deflater

    config.active_record.raise_in_transactional_callbacks = true

    Jbuilder.key_format camelize: :lower
  end
end