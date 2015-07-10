source 'https://rubygems.org'
ruby '2.2.1'

gem 'rails',                  '4.2.0'
gem 'puma',                   '2.11.1'
gem 'secure_headers',         '1.4.1'
gem 'jquery-rails',           '4.0.3'
gem 'turbolinks',             '2.5.3'
gem 'jbuilder',               '2.2.6'
gem 'slim-rails',             '3.0.1'
gem 'pg',                     '0.18.1'
gem 'sass-rails',             '5.0.3'
gem 'coffee-rails',           '4.1.0'
gem 'uglifier',               '2.7.0'
gem 'simple_form',            '3.1.0'
gem 'flutie',                 '2.0.0'
gem 'bourbon',                '4.1.1'
gem 'neat',                   '1.7.1'
gem 'bitters',                '1.0.0'
gem 'refills',                '0.1.0'
gem 'normalize-rails',        '3.0.1'

group :production, :staging do
  gem 'rails_12factor',       '0.0.3'
  gem 'rack-canonical-host',  '0.1.0'
  gem 'rack-timeout',         github: 'kch/rack-timeout', ref: '83ca9f5141c1fdcb626820b1601c406e3a3a560a'
  gem 'newrelic_rpm',         '3.9.9.275'
  gem 'rollbar',              '1.4.0'
  gem 'librato-rails',        '0.11.1'
end

group :development do
  gem 'foreman',              '0.77.0'
  gem 'jumpup',               '0.0.8'
  gem 'jumpup-heroku',        '0.0.6'
  gem 'better_errors',        '2.1.1'
  gem 'binding_of_caller',    '0.7.2'
  gem 'letter_opener',        '1.3.0'
  gem 'bullet',               '4.14.0'
  gem 'quiet_assets',         '1.1.0'
end

group :test do
  gem 'shoulda-matchers',     '2.7.0', require: false
  gem 'simplecov',            '0.9.1', require: false
  gem 'email_spec',           '1.6.0'
  gem 'capybara',             '2.4.4'
  gem 'poltergeist',          '1.5.1'
  gem 'vcr',                  '2.9.3'
  gem 'webmock',              '1.20.4'
  gem 'database_cleaner',     '1.4.0'
end

group :development, :test do
  gem 'rspec-rails',           '3.1.0'
  gem 'factory_girl_rails',    '4.5.0'
  gem 'pry-rails',             '0.3.2'
  gem 'dotenv-rails',          '1.0.2'
  gem 'awesome_print',         '1.6.1'
  gem 'spring-commands-rspec', '1.0.4'
  gem 'byebug',                '3.5.1'
  gem 'web-console',           '2.0.0'
  gem 'spring',                '1.2.0'
end
