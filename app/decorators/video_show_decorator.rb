class VideoShowDecorator < VideoDecorator

  delegate(
    :description,
    to: :video
  )

  def user_is_entitled?
    current_session.authenticated? && VideoEntitlement.entitled?(video, access_token: current_session.access_token)
  end

  def player_url
    "https://player.zype.com/embed/#{video.id}.html?#{player_access_query}"
  end

  def back_to_library_url
    current_session.try(:last_library_url) || :back
  end

private

  # We can't use the Players API as it doesn't accept an access token.
  # However, it seems that the players API is behind an auth wall (requires auth_token).
  # This means that we have to build the URL ourselves, manually passing the access token.
  def player_access_query
    current_session.authenticated? ? "access_token=#{current_session.access_token}" : "api_key=#{Settings.zype.api_key}"
  end

end