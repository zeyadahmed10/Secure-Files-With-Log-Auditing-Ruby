require 'rails_helper'

RSpec.describe "Api::V1::Auths", type: :request do
  let(:valid_sign_params) do
    rng = Random.new
    val = rng.rand(100000000)
    {
      username: "user#{val}",
      password: "password"
    }
  end
  let(:valid_signup_params) do
    rng = Random.new
    val = rng.rand(100000000) 
    {
      username: "validusername#{val}",
      password: "validpassword",
      email: "valid#{val}@securefile.com",
      firstName: "firstname",
      lastName: "lastname",
      role: "user"
    }
  end
  describe "POST /api/v1/auth/signin" do
    context "when using valid signin params" do
      it "signs up the user and returns 200 status and generated JWT" do
        # Sign up the user
        post '/api/v1/auth/signup', params: {
          username: valid_sign_params[:username],
          password: valid_sign_params[:password],
          firstName: 'Test',
          lastName: 'User',
          email: "#{valid_sign_params[:username]}@example.com",
          role: 'user'
        }

        # Expect successful signup response
        expect(response.status).to be_between(200,209).inclusive

        # Sign in with the same credentials
        post '/api/v1/auth/signin', params: valid_sign_params

        # Expect successful signin response
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to have_key("access_token") # assuming JWT token is returned in response
      end
    end
    context "when using invalid sign in params" do
      it "should return 401" do
        post '/api/v1/auth/signin', params: {username: "invalid", password: "invalid"}
        expect(response.status).to eq(401)
      end
    end  
  end
  
  describe "POST /api/v1/auth/signup" do
    context "when using valid signup params" do
      it "should return 200 ok" do
        post "/api/v1/auth/signup", params: valid_signup_params
        expect(response.status).to eq(204)
      end
    end
    context "when using invalid signup params" do
      it "should return 400 bad request when choosing role not ('user' , 'admin')" do
        post "/api/v1/auth/signup", params: {
          username: "validusername",
          password: "validpassword",
          email: "valid@securefile.com",
          firstName: "firstname",
          lastName: "lastname",
          role: "invalid_role"
        }
        expect(response.status).to eq(400)
      end
      it "should return 409 when using existing email or user" do
        post "/api/v1/auth/signup" , params: valid_signup_params
        post "/api/v1/auth/signup" , params: valid_signup_params
        expect(response.status).to eq(409)
      end
    end
  end
end
