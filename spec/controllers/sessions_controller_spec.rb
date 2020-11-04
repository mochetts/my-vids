require 'rails_helper'

RSpec.describe SessionsController do
  let(:right_credentials) { { username: 'test@test.com', password: 'password' } }
  let(:wrong_credentials) { { username: 'test@test.com', password: 'wrong' } }
  let(:auth_response) { logged_in_session_fixture }

  before do
    allow_any_instance_of(My::Oauth).to receive(:create).with(params: right_credentials.merge(OauthSession::OAUTH_PARAMS)).and_return(auth_response)
    allow_any_instance_of(My::Oauth).to receive(:create).with(params: wrong_credentials.merge(OauthSession::OAUTH_PARAMS)).and_raise(Zype::Client::Unauthorized)
  end

  describe 'POST create' do
    it 'successful' do
      post :create, params: right_credentials
      auth_response.each { |key, value|
        expect(session[key]).to eq(value), "#{key} wasn't properly stored in session. Expected: #{value}, Actual: #{session[key]}"
      }
    end

    it 'wrong credentials' do
      post :create, params: wrong_credentials
      expect(session[:access_token]).to be_nil
    end
  end

  describe 'DELETE destroy' do
    it 'successful' do
      post :create, params: right_credentials
      expect(session[:access_token]).not_to be_nil
      delete :destroy
      expect(session[:access_token]).to be_nil
    end
  end
end