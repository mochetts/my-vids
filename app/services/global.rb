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
    raise e unless Rails.env.local?
  end
end
