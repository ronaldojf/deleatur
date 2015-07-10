Jumpup::Heroku.configure do |config|
  config.app = 'deleatur'
end if Rails.env.development?
