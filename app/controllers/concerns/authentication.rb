module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

private

  def authenticate
    if session_expired?
      redirect_to new_session_url, notice: 'Your session expired'
    elsif needs_refresh?
      oauth_session.refresh
    else
    end
  end

  def session_expired?
    oauth_session.expired?
  end

  def needs_refresh?
    oauth_session.needs_refresh?
  end

end