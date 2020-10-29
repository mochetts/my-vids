module SessionsHelper
  def oauth_session
    @oauth_session ||= OauthSession.from(session)
  end
end
