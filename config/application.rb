require_relative "boot"

require "rails"
require "action_controller/railtie"
require "action_view/railtie"
require "github"

Bundler.require(*Rails.groups)

# Eager load leaky dependency to workaround AS::Dependencies unloading issues
#   https://github.com/rmosolgo/graphql-ruby/pull/240
require "graphql"
GraphQL::BOOLEAN_TYPE.name

module GitHub
  class Application < Rails::Application
  end
end
