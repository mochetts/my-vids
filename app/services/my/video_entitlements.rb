class My::VideoEntitlements < Zype::VideoEntitlements
  include Singleton
  include My::Base

  def initialize(auth = 'api_key')
    super(auth)
  end
end