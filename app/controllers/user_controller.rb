class UserController < ApplicationController
    before_action :authorized, only: [:auto_login]
  
    # REGISTER
    def create
      @user = User.create!(user_params)
      if @user.valid?
        token = encode_token({user_id: @user.id.to_s})
        render json: {user: @user, token: token, status: "success"}, status: :created
      else
        render json: {error: "Invalid username or password", status: "failed"}
      end
    end
  
    # LOGGING IN
    def login
      @user = User.where(email: params[:email]).first
  
      if @user && @user.authenticate(params[:password])
        token = encode_token({user_id: @user.id.to_s})
        render json: {token: token,  status: "success"}, status: :ok
      else
        render json: {error: "Invalid username or password", status: "failed"}, status: :unauthorized
      end
    end
  
  
    def auto_login
      render json: @user
    end
    def logout
      render json: {messgae: "Logged Out", status: "success"}
    end
    private
  
    def user_params
      params.permit(:name, :email, :password)
    end
  
  end