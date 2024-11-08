class Api::V1::AuthController < ApplicationController
    def signin
        singin_params = require_signin_params
        result = KeycloakService.new.signin(singin_params[:username], singin_params[:password])
        render json: result.parsed_response , status: result.code
        
    end
    def signup
        signup_params = require_signup_params
        result = KeycloakService.new.signup(signup_params)
        if result.is_a?(Hash)
          render json: {errorMessage: result[:error]}, status: result[:code]
          return
        end
        render json: result.parsed_response, status: result.code
    end
    private
        def require_signin_params
            params.require(:username)
            params.require(:password)
            params.permit(:username, :password)
        end

        def require_signup_params
          params.require(:username)
          params.require(:password)
          params.require(:firstName)
          params.require(:lastName)
          params.require(:email)
          params.require(:role)
          params.permit(:username, :password, :email, :firstName, :lastName, :role)
        end
    
end
