require 'rails_helper'

RSpec.describe VideoDecorator do
  let(:video) { Video.find(1) }
  let(:decorated_video) { VideoDecorator.new(video) }

  before do
    # Stub API calls
    allow(My::Videos).to receive(:find).and_return(video_fixture)
    allow_any_instance_of(My::VideoEntitlements).to receive(:entitled).and_return(entitled_fixture)
  end

  context 'should expose the right attributes' do
    it 'title' do
      expect(decorated_video.title).to eq video.title
    end

    it 'description' do
      expect(decorated_video.description).to eq video.description
    end

    it 'short_description' do
      expect(decorated_video.short_description).to eq video.short_description
    end

    it 'needs_subscription?' do
      expect(decorated_video.needs_subscription?).to eq video.subscription_required
    end

    it 'free?' do
      expect(decorated_video.free?).to eq !video.subscription_required
    end

    context 'thumbnail' do
      it '480' do
        expect(decorated_video.thumbnail).to eq video.thumbnails.find { |t| t.symbolize_keys[:height] == 480 }
      end

      it 'default' do
        video.thumbnails.reject! { |t| t.symbolize_keys[:height] == 480 }
        expect(decorated_video.thumbnail).to eq video.thumbnails.first
      end
    end

    it 'created_at' do
      expect(decorated_video.created_at).to eq DateTime.parse(video.created_at).strftime('%b %e, %Y')
    end

    context 'user_is_entitled' do
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

    context 'cache_key' do
      it 'authenticated', :authenticated do
        expect(decorated_video.cache_key).to eq ['video', video.cache_key, 'test@test.com'].join('/')
      end

      it 'not authenticated' do
        expect(decorated_video.cache_key).to eq ['video', video.cache_key, 'public'].join('/')
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