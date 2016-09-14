namespace :schema do
  # The public schema will evolve over time, so you'll want to periodically
  # refetch the latest and check in the changes.
  #
  # An offline copy of the schema allows queries to be typed checked statically
  # before even sending a request.
  desc "Update GitHub GraphQL schema"
  task :update do
    File.open("db/schema.json", 'w') do |f|
      GraphQL::Client.dump_schema(GitHub::HTTPAdapter, f)
    end
  end
end
