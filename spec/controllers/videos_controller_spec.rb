require 'rails_helper'

RSpec.describe VideosController do
  let(:video_attrs) { video_fixture }

  describe 'GET show' do
    describe 'with existing video' do
      before do
        allow_any_instance_of(My::Videos).to receive(:find).and_return(video_attrs)
      end

      it 'should show the video when authenticated', :authenticated do
        get :show, params: { id: video_attrs[:_id] }
        expect(response.status).to eq 200
      end

      it 'should ask for credentials when not authenticated' do
        get :show, params: { id: video_attrs[:_id] }
        response.should redirect_to new_session_path
      end

      it 'refreshes token', authenticated: { created_at: 8.days.ago.to_i } do
        current_time = Time.current.to_i
        allow(My::Oauth).to receive(:create).and_return(created_at: current_time)
        get :show, params: { id: video_attrs[:_id] }
        expect(session[:created_at]).to eq current_time
      end
    end

    describe 'with non existing video' do
      before do
        allow_any_instance_of(My::Videos).to receive(:find).and_raise(Zype::Client::NotFound)
      end

      it 'should show 404 when video is not found' do
        expect {
          get :show, params: { id: '12345' } # Non existing id
        }.to raise_error(ActionController::RoutingError, 'Not Found')
      end
    end
  end
end