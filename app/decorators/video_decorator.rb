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

  def free?
    !needs_subscription?
  end

  def thumbnail
    video.thumbnails.find { |t| t['height'] == 480 } || video.thumbnails.first
  end

  def created_at
    DateTime.parse(video.created_at).strftime('%b %e, %Y')
  end

  def user_is_entitled?
    needs_subscription? && VideoEntitlement.user_is_entitled_for?(video)
  end

  def player_url
    "https://player.zype.com/embed/#{video.id}.html?#{player_access_query}"
  end

private

  # We can't use the Players API as it doesn't accept an access token.
  # However, it seems that the players API is behind an auth wall (requires auth_token).
  # This means that we have to build the URL ourselves, manually passing the access token.
  def player_access_query
    current_session.authenticated? ? "access_token=#{current_session.access_token}" : 'api_key=roXcCjH-K5sec-d8IrBZ2AEIZttBAHdt3ivLAql6ywT9wytXbVF5xso1o70DgHcr'
  end
end