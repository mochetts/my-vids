class BaseModel
  delegate(
    :source,
    to: :class,
  )

  def initialize(attrs = {})
    # Add the errors bucket.
    attrs.merge!(errors: []) if attrs[:errors].nil?

    # Add instance varialbes for all attrs
    attrs.each do |attr, value|
      attr = 'id' if attr == '_id'

      instance_var = "@#{attr}".to_sym
      # Set instance variable
      instance_variable_set(instance_var, value)
      # Setter
      define_singleton_method("#{attr}=") { |val| instance_variable_set(instance_var, val) }
      # Getter
      define_singleton_method(attr) { instance_variable_get(instance_var) }
    end
  end

  def self.sourced_from(source_class)
    @source = source_class
  end

  def self.source
    @source
  end

  def self.to_proc
    ->(args) { new(args) }
  end

  def self.all(**params)
    source.all(params: params).map(&self)
  end

  def self.find(id)
    begin
      new(source.find(id: id))
    rescue Zype::Client::NotFound => e
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def self.create(**params)
    new(source.create(params: params))
  end

  def has_errors?
    errors.any?
  end

  def cache_key
    [self.class, self.id].join('/')
  end
end