require 'rails_helper'

RSpec.describe VideoShowDecorator do
  let(:decorated_video) { VideoShowDecorator.new(video) }

  video_decorator_shared_examples

  context 'should expose the right show attributes' do

    before do
      # Stub API calls
      allow_any_instance_of(My::VideoEntitlements).to receive(:entitled).and_return(entitled_fixture)
    end

    it 'description' do
      expect(decorated_video.description).to eq video.description
    end

    context 'user_is_entitled?' do
      it 'authenticated', :authenticated do
        expect(decorated_video.user_is_entitled?).to eq true
      end

      it 'not authenticated' do
        expect(decorated_video.user_is_entitled?).to eq false
      end

      it 'authenticated but not entitled', :authenticated do
        allow_any_instance_of(My::VideoEntitlements).to receive(:entitled).and_raise(Zype::Client::UnprocessableEntity)
        expect(decorated_video.user_is_entitled?).to eq false
      end
    end

    context 'player_url' do
      it 'authenticated', :authenticated do
        expect(decorated_video.player_url).to eq "https://player.zype.com/embed/#{video.id}.html?access_token=#{current_session.access_token}"
      end

      it 'not authenticated' do
        expect(decorated_video.player_url).to eq "https://player.zype.com/embed/#{video.id}.html?api_key=#{Settings.zype.api_key}"
      end
    end

    context 'back_to_library_url' do
      it 'authenticated', :authenticated do
        expect(decorated_video.back_to_library_url).to eq current_session.last_library_url
      end

      it 'not authenticated' do
        expect(decorated_video.back_to_library_url).to eq :back
      end
    end
  end
end