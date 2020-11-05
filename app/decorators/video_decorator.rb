class VideoDecorator < BaseDecorator
  decorates :video

  delegate(
    :title,
    to: :video
  )

  def needs_subscription?
    video.subscription_required
  end

  def free?
    !needs_subscription?
  end

  def created_at
    DateTime.parse(video.created_at).strftime('%b %e, %Y')
  end

  def cache_key
    ['video', video.cache_key, current_session.cache_key].join('/')
  end

end