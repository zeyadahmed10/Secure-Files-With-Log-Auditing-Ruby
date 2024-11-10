class KeycloakService
    include HTTParty
  
    def initialize
      @auth_domain = Rails.application.config.auth[:domain]
      @token_endpoint = Rails.application.config.auth[:token_endpoint]
      @users_endpoint = Rails.application.config.auth[:users_endpoint]
      @roles_endpoint = Rails.application.config.auth[:roles_endpoint]
      @client_id = Rails.application.config.auth[:client_id]
      @client_secret = Rails.application.config.auth[:client_secret]
      @admin_role = Rails.application.config.auth[:admin_role]
      @user_role = Rails.application.config.auth[:user_role]
      @roles_hash = {user: @user_role, admin: @admin_role}
    end
  
    def signup(user_params)
      role_id = @roles_hash[user_params[:role].to_sym]
      if role_id.nil?
        return { error: 'Selected Role is not valid. Please select either "admin" or "user".' , code: 400}  
      end 
      token = get_client_credentials_token
      return token unless token.is_a?(String)
  
      url = "#{@auth_domain}#{@users_endpoint}"
      headers = { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{token}" }
      body = {
        username: user_params[:username],
        firstName: user_params[:firstName],
        lastName: user_params[:lastName],
        email: user_params[:email],
        emailVerified: true,
        enabled: true,
        credentials: [{ type: "password", value: user_params[:password] }]
        }
      response = self.class.post(url, headers: headers, body: body.to_json)
  
      if response.code != 201
        return response
      end
      user_id = response.headers['location'].split('/').last
      assign_role(user_id, token, user_params[:role])
    end
  
    def signin(username, password)
      url = "#{@auth_domain}#{@token_endpoint}"
      headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
      body = {
        'client_id' => @client_id,
        'client_secret' => @client_secret,
        'grant_type' => 'password',
        'username' => username,
        'password' => password
      }
      response = self.class.post(url, headers: headers, body: URI.encode_www_form(body))
      return response
    end
  
    private
  
    def get_client_credentials_token
      url = "#{@auth_domain}#{@token_endpoint}"
      headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
      body = {
        'client_id' => @client_id,
        'client_secret' => @client_secret,
        'grant_type' => 'client_credentials'
      }
      response = self.class.post(url, headers: headers, body: URI.encode_www_form(body))
  
      if response.code == 200
        response.parsed_response['access_token']
      else
        return response
      end
    end
  
    def assign_role(user_id, token, role)
      url = "#{@auth_domain}#{@users_endpoint}/#{user_id}#{@roles_endpoint}"
      headers = { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{token}" }
      role_id = @roles_hash[role.to_sym]
      body = [{ id: role_id, name: role }]
      self.class.post(url, headers: headers, body: body.to_json)
    end
  end  