class BasePresenter
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  def current_session
    Current.session
  end
end