module My::Base
  extend ActiveSupport::Concern

  def initialize
    super('app_key')
  end

  class_methods do
    def method_missing(method_name, *args, &block)
      if instance.respond_to?(method_name)
        instance.send(method_name, *args, &block)
      else
        super
      end
    end
  end
end