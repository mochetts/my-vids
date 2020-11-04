class BaseModel
  delegate(
    :source,
    to: :class,
  )

  class << self
    def sourced_from(source_class)
      @source = source_class
    end

    def source
      @source
    end

    def to_proc
      ->(args) { new(args) }
    end

    def all(**params)
      source.all(params: params).map(&self)
    end

    def find(id)
      new(source.find(id: id))
    end
  end

  def initialize(attrs = {})
    # Add the errors bucket.
    attrs.merge!(errors: []) if attrs[:errors].nil?

    # Add instance varialbes for all attrs
    attrs.each do |attr, value|
      attr = 'id' if attr == '_id' || attr == :_id

      instance_var = "@#{attr}".to_sym
      # Set instance variable
      instance_variable_set(instance_var, value)
      # Setter
      define_singleton_method("#{attr}=") { |val| instance_variable_set(instance_var, val) }
      # Getter
      define_singleton_method(attr) { instance_variable_get(instance_var) }
    end
  end

  def has_errors?
    errors.any?
  end

  def attributes
    instance_variables.inject({}) do |attrs, instance_var|
      value = instance_variable_get(instance_var)
      key = instance_var.to_s.tr('@', '').to_sym
      attrs.merge(key => value)
    end
  end

  def cache_key
    [self.class, self.id].join('/')
  end
end