require File.expand_path('../../app/models/settings', __dir__)

Zype.configure do |config|
  config.app_key = Settings.zype.app_key
  config.api_key = Settings.zype.api_key
end