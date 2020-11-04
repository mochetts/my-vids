module My::Base
  extend ActiveSupport::Concern

  def initialize(auth = 'app_key')
    super(auth)
  end

  class_methods do
    def method_missing(method_name, *args, &block)
      if instance.respond_to?(method_name)
        begin
          instance.send(method_name, *args, &block)
        rescue Zype::Client::NotFound => e
          raise ActionController::RoutingError.new('Not Found')
        end
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      super || instance.respond_to?(method_name, include_private)
    end
  end
end