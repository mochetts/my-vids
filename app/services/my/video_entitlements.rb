class My::VideoEntitlements < Zype::VideoEntitlements
  include Singleton
  include My::Base

  def initialize(auth = 'api_key')
    super(auth)
  end

  class << self
    def entitled?(video, access_token: nil)
      begin
        instance.entitled(video_id: video.id, access_token: access_token)['message'] == 'entitled'
      rescue Zype::Client::GenericError, Zype::Client::UnprocessableEntity => e
        false
      end
    end
  end
end