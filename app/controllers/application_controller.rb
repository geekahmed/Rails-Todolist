class ApplicationController < ActionController::API
    before_action :authorized

    rescue_from Mongoid::Errors::DocumentNotDestroyed, with: :not_destroyed
    rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found_e
    rescue_from Mongoid::Errors::Validations, with: :validation_error_callback
    def encode_token(payload)
        JWT.encode(payload, 'my secret', 'HS256')
    end

    def auth_header
        # { Authorization: 'Bearer <token>' }
        request.headers['Authorization']
    end

    def decoded_token
        if auth_header
        token = auth_header.split(' ')[1]
        # header: { 'Authorization': 'Bearer <token>' }
        begin
            JWT.decode(token, 'my secret', true, algorithm: 'HS256')
        rescue JWT::DecodeError
            nil
        end
        end
    end

    def logged_in_user
        if decoded_token
        user_id = decoded_token[0]['user_id']
        @user = User.find(id: user_id)
        end
    end

    def logged_in?
        !!logged_in_user
    end

    def authorized
        render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    end

    private
    def not_destroyed(err)
        render json: {error: err.problem,  status: "failed"}, status: :unprocessable_entity
    end
    def not_found_e(err)
        render json: {error: err.problem,  status: "failed"}, status: :not_found
    end
    def validation_error_callback(err)
        render json: {error: err.problem,  status: "failed"}, status: :unprocessable_entity
    end
end
