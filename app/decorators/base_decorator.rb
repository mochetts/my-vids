class BaseDecorator
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  def initialize(object)
    @object = object
  end

  def self.decorates(name)
    define_method(name) { @object }
  end

  def self.to_proc
    ->(video) { new(video) }
  end
end