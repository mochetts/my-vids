# Public: API to read environment variables, which allows us to be very strict
# on servers where we want everything to be configured, and lenient on our locals.
module Global
  # Public: Read an environment variable.
  #
  # name    - Name of the env variable.
  # default - (Optional) Value to be used if the env variable is not set.
  def self.get(*args, &block)
    ENV.fetch(*args, &block)
  rescue KeyError => e
    Rails.env.server_only { raise e }
  end

  # Override: In the security audit we use 'fake_config_value' as a way to
  # validate that all secrets are set as environment variables.
  if defined?(SECURITY_AUDIT)
    def self.get(*)
      'fake_config_value'
    end
  end
end
