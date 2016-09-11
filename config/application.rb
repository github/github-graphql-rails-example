require_relative "boot"

require "rails"
require "action_controller/railtie"
require "action_view/railtie"
require "graphql/client/railtie"
require "graphql/client/http"

Bundler.require(*Rails.groups)

module GitHub
  class Application < Rails::Application
  end

  HTTPAdapter = GraphQL::Client::HTTP.new("https://api.github.com/graphql") do
    def headers(query)
      token = query.context[:access_token] || Application.secrets.github_access_token
      {
        "Authorization" => "Bearer #{token}"
      }
    end
  end

  Client = GraphQL::Client.new(
    schema: Application.root.join("db/schema.json").to_s,
    fetch: HTTPAdapter
  )
  Application.config.graphql.client = Client
end
