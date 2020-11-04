class My::Oauth < Zype::Oauth
  include Singleton
  include My::Base

  class Unauthorized < StandardError; end

  class << self
    def create(params: {})
      begin
        instance.create(params: params)
      rescue Zype::Client::Unauthorized => e
        raise Unauthorized
      end
    end
  end
end