class BaseDecorator
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  attr_reader :object

  delegate(
    :id,
    to: :object
  )

  def initialize(object)
    @object = object
  end

  def self.decorates(name)
    define_method(name) { object }
  end

  def self.to_proc
    ->(o) { new(o) }
  end

  def current_session
    Current.session
  end
end