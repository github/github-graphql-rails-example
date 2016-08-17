require "json"
require "net/http"
require "uri"

module GitHub
  URI = URI.parse("https://api.github.com/graphql")
  Token = ENV.fetch("GITHUB_API_TOKEN")

  def self.fetch(query, variables = {})
    http = Net::HTTP.new(URI.host, URI.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(URI.request_uri)
    request["Authorization"] = "Bearer #{Token}"

    request.body = JSON.generate({
      "query" => query,
      "variables" => JSON.generate(variables)
    })

    response = http.request(request)
    JSON.parse(response.body)["data"]
  end
end
