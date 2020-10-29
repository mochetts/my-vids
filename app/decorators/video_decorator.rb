class VideoDecorator < BaseDecorator
  decorates :video

  delegate(
    :title,
    :description,
    :short_description,
    to: :video
  )

  def needs_subscription?
    video.subscription_required
  end

  def thumbnail
    video.thumbnails.find { |t| t['height'] == 480 } || video.thumbnails.first
  end

  def created_at
    DateTime.parse(video.created_at).strftime('%b %e, %Y')
  end
end