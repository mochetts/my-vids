module My::Base
  extend ActiveSupport::Concern

  def initialize(auth = 'app_key')
    super(auth)
  end

  class_methods do
    def method_missing(method_name, *args, &block)
      if instance.respond_to?(method_name)
        instance.send(method_name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      super || instance.respond_to?(method_name, include_private)
    end
  end
end