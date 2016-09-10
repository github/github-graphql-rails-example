require "json"
require "net/http"
require "uri"

module GitHub
  # Very simple Net::HTTP based network adapter that POSTs requests to the
  # GitHub GraphQL endpoint.
  #
  # A production application would likely use a more sophisticated network
  # stack. Maybe something like the Faraday (https://github.com/lostisland/faraday)
  # gem.
  class HTTPAdapter
    QUERY_URI = ::URI.parse("https://api.github.com/graphql")

    # Public: Make GraphQL network request.
    #
    # document - A parsed GraphQL::Language::Nodes::Document object of the query
    #            string.
    # operation_name - A String operation name to execute from the document.
    # variables - A Hash of variables to use while executing the document
    #             operation.
    # context - A Hash of application specific context information passed to
    #           the query method. The context object is a great place for
    #           OAuth tokens to be passed along.
    #
    # Returns a Hash GraphQL response, { "data" => ..., "errors" => ... }.
    def self.call(document, operation_name, variables, context)
      http = Net::HTTP.new(QUERY_URI.host, QUERY_URI.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(QUERY_URI.request_uri)
      request["Authorization"] = "Bearer #{context[:access_token]}" if context[:access_token]

      # TODO: GitHub's /graphql endpoint doesn't accept operation names
      request.body = JSON.generate({
        "query" => document.to_query_string,
        "variables" => JSON.generate(variables)
      })

      response = http.request(request)
      JSON.parse(response.body)
    end
  end
end
