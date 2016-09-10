require_relative "boot"

require "rails"
require "action_controller/railtie"
require "action_view/railtie"
require "graphql/client/railtie"

Bundler.require(*Rails.groups)

module GitHub
  class Application < Rails::Application
  end
end
