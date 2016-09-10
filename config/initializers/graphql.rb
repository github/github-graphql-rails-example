require "graphql/client/http"

module GitHub
  HTTPAdapter = GraphQL::Client::HTTP.new("https://api.github.com/graphql") do
    def headers(query)
      token = query.context[:access_token] || GitHub::Application.secrets.github_access_token
      {
        "Authorization" => "Bearer #{token}"
      }
    end
  end

  # The GraphQL::Client configured with GitHub's schema and network adapter.
  #
  # GraphQL::Client provides two main APIs:
  #
  #   # Parse GraphQL query string and return a parsed definition.
  #   VersionQuery = GitHub::Client.parse("query { version }")
  #
  #   # Execute query definition
  #   data = GitHub::Client.query(VersionQuery)
  #   data.version #=> 42
  #
  Client = GraphQL::Client.new(
    schema: GitHub::Application.root.join("db/schema.json").to_s,
    fetch: GitHub::HTTPAdapter
  )
end

GitHub::Application.config.graphql.client = GitHub::Client
