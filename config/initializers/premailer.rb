Premailer::Rails.config.merge!({
  remove_ids: true,
  css: File.expand_path('../../../app/assets/stylesheets/email', __FILE__),
  base_url: "http://#{ENV['URL'] || 'localhost:3000'}",
  remove_classes: true,
  remove_comments: true,
  adapter: :nokogiri,
  verbose: true
})
