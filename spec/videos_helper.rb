def video_decorator_shared_examples
  let(:video) { Video.new(video_fixture) }

  context 'should expose the right video decorator attributes' do
    it 'title' do
      expect(decorated_video.title).to eq video.title
    end

    it 'needs_subscription?' do
      expect(decorated_video.needs_subscription?).to eq video.subscription_required
    end

    it 'free?' do
      expect(decorated_video.free?).to eq !video.subscription_required
    end

    it 'created_at' do
      expect(decorated_video.created_at).to eq DateTime.parse(video.created_at).strftime('%b %e, %Y')
    end

    context 'cache_key' do
      it 'authenticated', :authenticated do
        expect(decorated_video.cache_key).to eq ['video', video.cache_key, 'test@test.com'].join('/')
      end

      it 'not authenticated' do
        expect(decorated_video.cache_key).to eq ['video', video.cache_key, 'public'].join('/')
      end
    end
  end
end