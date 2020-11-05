require 'rails_helper'

RSpec.describe VideoIndexDecorator do
  let(:decorated_video) { VideoIndexDecorator.new(video) }

  video_decorator_shared_examples

  context 'should expose the right index attributes' do

    it 'short_description' do
      expect(decorated_video.short_description).to eq video.short_description
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
  end
end