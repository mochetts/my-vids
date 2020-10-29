module SessionsHelper
  def oauth_session
    Current.session
  end
end
