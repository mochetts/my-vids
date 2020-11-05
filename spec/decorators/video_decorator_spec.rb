require 'rails_helper'

RSpec.describe VideoDecorator do
  let(:decorated_video) { VideoDecorator.new(video) }

  video_decorator_shared_examples
end