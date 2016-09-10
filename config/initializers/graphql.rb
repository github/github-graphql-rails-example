require "github/http_adapter"

# Load this cached file from the FS. The schema should periodically be
# refetched via `rake schema:update`.
GitHub::Application.config.graphql.schema = GraphQL::Schema::Loader.load(JSON.parse(File.read("#{Rails.root}/db/schema.json")))

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
GitHub::Application.config.graphql.client = GraphQL::Client.new(
  schema: GitHub::Application.config.graphql.schema,
  fetch: GitHub::HTTPAdapter
)

module GitHub
  Client = GitHub::Application.config.graphql.client
end
