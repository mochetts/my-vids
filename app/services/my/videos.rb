module My
  class Videos < Zype::Videos
    include Singleton

    def initialize
      super('app_key')
    end

    def self.method_missing(method_name, *args, &block)
      if instance.respond_to?(method_name)
        instance.send(method_name, *args, &block)
      else
        super
      end
    end
  end
end