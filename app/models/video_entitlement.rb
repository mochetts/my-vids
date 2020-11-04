class VideoEntitlement < BaseModel
  sourced_from My::VideoEntitlements

  class << self
    def entitled?(video, access_token: nil)
      source.entitled?(video, access_token: access_token)
    end
  end
end