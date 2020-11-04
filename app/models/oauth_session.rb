class OauthSession < BaseModel
  sourced_from My::Oauth

  OAUTH_PARAMS = {
    client_id: Settings.zype.client_id,
    client_secret: Settings.zype.client_secret,
    grant_type: 'password'
  }.freeze

  # Asks for a new Oauth session to the remote source.
  #
  # @param params [Hash] the credentials used for authentication
  # @return [Session] the Session object containing the auth information
  def self.create(**credentials)
    credentials.merge!(OAUTH_PARAMS)
    begin
      oauth_attrs = source.create(params: credentials)
      oauth_attrs.merge!(
        expires_at: Time.current + Settings.session.expiration.days,
        **credentials.slice(:username, :password)
      )
      new(oauth_attrs)
    rescue My::Oauth::Unauthorized => e
      new(errors: ['Wrong email or password'])
    end
  end

  # Creates a new Session object out of a web session
  #
  # @param params [Hash] the web session
  # @return [Session] the Session object containing wrapping the web session
  def self.from(session)
    new(session)
  end

  # Saves the Session to the web session
  #
  # @param params [Hash] the web session
  # @return [Session] self
  def save_to(session)
    attributes.each do |key, value|
      session[key] = value
    end
    self
  end

  # Determines if the oauth session is expired
  #
  # @return [Boolean]
  def expired?
    !respond_to?(:expires_at) || expires_at < Time.current
  end

  # Determines if the oauth session needs a token refresh from the oauth provider.
  # We'll be refreshing tokens one day before expiration as we want to manage the expiration ourselves.
  #
  # @return [Boolean]
  def needs_refresh?
    !respond_to?(:created_at) || ((Time.at(created_at) + expires_in.seconds) < Time.current - 1.day)
  end

  # Determines if the current session is authenticated
  #
  # @return [Boolean]
  def authenticated?
    !expired? && respond_to?(:access_token) && access_token.present?
  end

  # Determines if the oauth session needs a token refresh from the oauth provider
  # We'll be refreshing tokens one day before expiration.
  #
  # @return [Boolean]
  def refresh
    begin
      oauth_attrs = source.create(params: refresh_token_params)
      oauth_attrs.each do |attr, value|
        send("#{attr}=", value)
      end
    rescue My::Oauth::Unauthorized => e
      errors << 'Error refreshing token'
    end
    self
  end

  # Cache key used for view caching
  #
  # @return [String]
  def cache_key
    try(:username) || 'public'
  end

private

  def refresh_token_params
    attributes.slice(:username, :password, :refresh_token).merge(OAUTH_PARAMS)
  end
end