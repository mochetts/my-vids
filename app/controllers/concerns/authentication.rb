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
      oauth_session.refresh
    end
  end

  def session_expired?
    oauth_session.expired?
  end

  def needs_refresh?
    oauth_session.needs_refresh?
  end

  def oauth_session
    Current.session
  end

end