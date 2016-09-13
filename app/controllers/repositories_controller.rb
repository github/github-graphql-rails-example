class RepositoriesController < ApplicationController
  # Define query for repository listing.
  #
  # All queries MUST be assigned to constants and therefore be statically
  # defined. Queries MUST NOT be generated at request time.
  IndexQuery = GitHub::Client.parse <<-'GRAPHQL'
    # All read requests are defined in a "query" operation
    query {
      # viewer is the currently authenticted User
      viewer {
        # "...FooConstant" is the fragment spread syntax to include the index
        # view's fragment.
        #
        # "Views::Repositories::Index::Viewer" means the fragment is defined
        # in app/views/repositories/index.html.erb and named Viewer.
        ...Views::Repositories::Index::Viewer
      }
    }
  GRAPHQL

  # GET /repositories
  def index
    # Use query helper defined in ApplicationController to execute the query.
    # `query` returns a GraphQL::Client::QueryResult instance with accessors
    # that map to the query structure.
    data = query IndexQuery

    # Render the app/views/repositories/index.html.erb template with our
    # current User.
    #
    # Using explicit render calls with locals is preferred to implicit render
    # with instance variables.
    render "repositories/index", locals: {
      viewer: data.viewer
    }
  end


  # Define query for "Show more repositories..." AJAX action.
  MoreQuery = GitHub::Client.parse <<-'GRAPHQL'
    # This query uses variables to accept an "after" param to load the next
    # 10 repositories.
    query($after: String!) {
      viewer {
        repositories(first: 10, after: $after) {
          # Instead of refetching all of the index page's data, we only need
          # the data for the repositories container partial.
          ...Views::Repositories::Repositories::RepositoryConnection
        }
      }
    }
  GRAPHQL

  # GET /repositories/more?after=CURSOR
  def more
    # Execute the MoreQuery passing along data from params to the query.
    data = query MoreQuery, after: params[:after]

    # Using an explicit render again, just render the repositories list partial
    # and return it to the client.
    render partial: "repositories/repositories", locals: {
      repositories: data.viewer.repositories
    }
  end


  # Define query for repository show page.
  ShowQuery = GitHub::Client.parse <<-'GRAPHQL'
    # Query is parameterized by a $id variable.
    query($id: ID!) {
      # Use global id Node lookup
      node(id: $id) {
        # Include fragment for app/views/repositories/show.html.erb
        ...Views::Repositories::Show::Repository
      }
    }
  GRAPHQL

  # GET /repositories/ID
  def show
    # Though we've only defined part of the ShowQuery in the controller, when
    # query(ShowQuery) is executed, we're sending along the query as well as
    # all of its fragment dependencies to the API server.
    #
    # Here's the raw query that's actually being sent.
    #
    # query RepositoriesController__ShowQuery($id: ID!) {
    #   node(id: $id) {
    #     ...Views__Repositories__Show__Repository
    #   }
    # }
    #
    # fragment Views__Repositories__Show__Repository on Repository {
    #   id
    #   owner {
    #     login
    #   }
    #   name
    #   description
    #   homepageURL
    #   ...Views__Repositories__Navigation__Repository
    # }
    #
    # fragment Views__Repositories__Navigation__Repository on Repository {
    #   hasIssuesEnabled
    # }
    data = query ShowQuery, id: params[:id]

    if repository = data.node
      render "repositories/show", locals: {
        repository: repository
      }
    else
      # If node can't be found, 404. This may happen if the repository doesn't
      # exist, we don't have permission or we used a global ID that was the
      # wrong type.
      head :not_found
    end
  end
end
