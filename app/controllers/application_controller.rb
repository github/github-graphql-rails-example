class ApplicationController < ActionController::Base
  # Public: GitHub's parsed GraphQL::Schema.
  #
  # Load this cached file from the FS. The schema should periodically be
  # refetched via `rake schema:update`.
  Schema = GraphQL::Schema::Loader.load(JSON.parse(File.read("#{Rails.root}/db/schema.json")))

  # Public: The GraphQL::Client configured with GitHub's schema and network
  # adapter.
  #
  # GraphQL::Client provides two main APIs:
  #
  #   # Parse GraphQL query string and return a parsed definition.
  #   VersionQuery = Client.parse("query { version }")
  #
  #   # Execute query definition
  #   data = Client.query(VersionQuery)
  #   data.version #=> 42
  #
  Client = GraphQL::Client.new(schema: Schema, fetch: GitHub::HTTPAdapter)

  private
    # Public: Define request scoped helper method for making GraphQL queries.
    #
    # Examples
    #
    #   data = query(ViewerQuery)
    #   data.viewer.login #=> "josh"
    #
    # definition - A query or mutation operation GraphQL::Client::Definition.
    #              Client.parse("query { version }") returns a definition.
    # variables - Optional set of variables to use during the operation.
    #             (default: {})
    #
    # Returns a structured query result or raises if the request failed with no
    # useful data.
    def query(definition, variables = {})
      response = Client.query(definition, variables: variables, context: client_context)

      case response
      when GraphQL::Client::SuccessfulResponse
        response.data
      when GraphQL::Client::FailedResponse
        # TODO: Just raise the first error from the response.
        # It'd be neat if the errors Array was actually an Errors collection
        # that extended StandardError so we could just `raise response.errors`
        # here.
        raise response.errors.first
      end
    end

    # Public: Useful helper method for tracking GraphQL context data to pass
    # along to the network adapter.
    def client_context
      unless access_token = Rails.application.secrets.github_access_token
        # $ GITHUB_ACCESS_TOKEN=abc123 bin/rails server
        #   https://help.github.com/articles/creating-an-access-token-for-command-line-use
        fail "Missing GitHub access token"
      end

      # Use static access token from environment. However, here we have access
      # to the current request so we could configure the token to be retrieved
      # from a session cookie.
      { access_token: access_token }
    end
end
