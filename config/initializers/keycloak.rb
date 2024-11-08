# config/initializers/keycloak.rb
Keycloak.configure do |config|
  config.server_url = ENV['KC_DOMAIN']
  config.realm_id = ENV['KC_REALM']
  config.logger = Rails.logger
  config.skip_paths = {
    post: [/^\/api\/v1\/auth\/signin/, /^\/api\/v1\/auth\/signup/]
  }
end
