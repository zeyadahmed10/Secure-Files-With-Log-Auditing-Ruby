# frozen_string_literal: true
if Rails.env.development? || Rails.env.test?
    require 'dotenv'
    Dotenv.load
end

Rails.application.config.auth = {
  domain: ENV['KC_DOMAIN'],
  realm: ENV['KC_REALM'],
  client_id: ENV['KC_CLIENT'],
  client_secret: ENV['KC_CLIENT_SECRET'],
  token_endpoint: ENV['AUTH_TOKEN_ENDPOINT'],
  users_endpoint: ENV['MANAGE_USERS_ENDPOINT'],
  roles_endpoint: ENV['MANAGE_ROLES_ENDPOINT'],
  admin_role: ENV['ADMIN_ROLE'],
  user_role: ENV['USER_ROLE']
}