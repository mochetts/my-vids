require 'rails_helper'

RSpec.describe OauthSession do

  context 'needs_refresh?' do
    let(:oauth_session) { OauthSession.new(logged_in_session_fixture) }

    context 'session expired' do
      before do
        allow(oauth_session).to receive(:created_at).and_return((Time.current - 8.days).to_i)
      end

      it 'should return true' do
        expect(oauth_session.needs_refresh?).to eq true
      end
    end

    it 'session is still alive' do
      expect(oauth_session.needs_refresh?).to eq false
    end
  end

  context 'refresh' do
    let(:oauth_session) {
      OauthSession.new(
        logged_in_session_fixture(
          created_at: (Time.current - 8.days).to_i
        )
      )
    }
    let(:current_time) { Time.current.to_i }

    before do
      allow(My::Oauth).to receive(:create).and_return(created_at: current_time)
    end

    it 'should update the created_at' do
      oauth_session.refresh
      expect(oauth_session.created_at).to eq current_time
    end

    it 'fails' do
      allow(My::Oauth).to receive(:create).and_raise(My::Oauth::Unauthorized)
      oauth_session.refresh
      expect(oauth_session.errors).to include('Error refreshing token')
    end
  end
end