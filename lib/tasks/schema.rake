namespace :schema do
  # The public schema will evolve over time, so you'll want to periodically
  # refetch the latest and check in the changes.
  #
  # An offline copy of the schema allows queries to be typed checked statically
  # before even sending a request.
  desc "Update GitHub GraphQL schema"
  task :update => [:environment, :clobber, "db/schema.json"]

  task :clobber do
    rm_f "db/schema.json"
  end

  directory "db"

  file "db/schema.json" => ["db", :environment] do
    File.open("db/schema.json", 'w') do |f|
      f.write(JSON.pretty_generate(GitHub::Client.fetch_schema))
    end
  end
end
