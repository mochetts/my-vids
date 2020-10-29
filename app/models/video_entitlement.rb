class VideoEntitlement < BaseModel
  sourced_from My::VideoEntitlements

  def self.user_is_entitled_for?(video)
    begin
      Current.session.authenticated? && source.entitled(video_id: video.id, access_token: Current.session.access_token)
      true
    rescue Zype::Client::GenericError, Zype::Client::UnprocessableEntity => e
      false
    end
  end
end