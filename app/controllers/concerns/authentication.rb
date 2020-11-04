module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

private

  def authenticate
    if session_expired?
      session[:intented_url] = request.url
      redirect_to new_session_url, notice: 'You need to sign in'
    elsif needs_refresh?
      current_session.refresh.save_to(session)
    end
  end

  def session_expired?
    current_session.expired?
  end

  def needs_refresh?
    current_session.needs_refresh?
  end

  def current_session
    Current.session
  end

end