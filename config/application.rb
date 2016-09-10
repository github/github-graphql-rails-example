require_relative "boot"

require "rails"
require "action_controller/railtie"
require "action_view/railtie"
require "github"

Bundler.require(*Rails.groups)

module GitHub
  class Application < Rails::Application
  end
end
