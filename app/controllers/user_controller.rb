class UserController < ApplicationController
    before_action :authorized, only: [:auto_login]
  
    # REGISTER
    def create
      @user = User.create!(user_params)
      if @user.valid?
        token = encode_token({user_id: @user.id.to_s})
        render json: {user: @user, token: token}
      else
        render json: {error: "Invalid username or password"}
      end
    end
  
    # LOGGING IN
    def login
      @user = User.where(email: params[:email]).first
  
      if @user && @user.authenticate(params[:password])
        token = encode_token({user_id: @user.id.to_s})
        render json: {user: @user, token: token}
      else
        render json: {error: "Invalid username or password"}
      end
    end
  
  
    def auto_login
      render json: @user
    end
  
    private
  
    def user_params
      params.permit(:name, :email, :password)
    end
  
  end