require 'rails_helper'

describe "Authentication", type: :request do

    describe "POST /login" do
        let(:user) {FactoryBot.create(:user, email: "newmail4@mail.com", password: "new pass")}
        it "authenticate the user" do
            post "/login", params: {"email": user.email, "password": user.password}
            expect(response).to have_http_status(:ok)
            expect(response.body).to include("token")
        end
        it "return error when the email is missing" do
            post "/login", params: {"password": user.password}
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.body).to eq({
                'error' => 'Invalid username or password'
            }.to_json)
        end
        it "return error when the password is missing" do
            post "/login", params: {"email": user.email}
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.body).to eq({
                'error' => 'Invalid username or password'   
            }.to_json)
        end
        it "return error when the password is wrong" do
            post "/login", params: {"email": user.email, "password": "pav"}
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.body).to eq({
                'error' => 'Invalid username or password'   
            }.to_json)
        end
    end
end