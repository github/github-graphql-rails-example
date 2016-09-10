class RepositoriesController < ApplicationController
  IndexQuery = GitHub::Client.parse <<-'GRAPHQL'
    query {
      viewer {
        ...Views::Repositories::Index::Viewer
      }
    }
  GRAPHQL

  def index
    data = query IndexQuery

    render "repositories/index", locals: {
      viewer: data.viewer
    }
  end


  MoreQuery = GitHub::Client.parse <<-'GRAPHQL'
    query($after: String!) {
      viewer {
        repositories(first: 10, after: $after) {
          ...Views::Repositories::Repositories::RepositoryConnection
        }
      }
    }
  GRAPHQL

  def more
    data = query MoreQuery, after: params[:after]

    render partial: "repositories/repositories", locals: {
      repositories: data.viewer.repositories
    }
  end


  ShowQuery = GitHub::Client.parse <<-'GRAPHQL'
    query($id: ID!) {
      node(id: $id) {
        ...Views::Repositories::Show::Repository
      }
    }
  GRAPHQL

  def show
    data = query ShowQuery, id: params[:id]

    if repository = data.node
      render "repositories/show", locals: {
        repository: repository
      }
    else
      head :not_found
    end
  end
end
