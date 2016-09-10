class RepositoriesController < ApplicationController
  IndexQuery = Client.parse <<-'GRAPHQL'
    query($after: String) {
      viewer {
        repositories(first: 10, after: $after) {
          totalCount
          pageInfo {
            hasNextPage
          }
          edges {
            cursor
            node {
              id
              owner {
                login
              }
              name
              isFork
              isMirror
              isPrivate
              stargazers(first: 1) {
                totalCount
              }
            }
          }
        }
      }
    }
  GRAPHQL

  def index
    data = query(IndexQuery, after: params[:after])

    if request.xhr?
      render partial: "repositories/repositories", locals: {
        repositories: data.viewer.repositories
      }
    else
      render "repositories/index", locals: {
        viewer: data.viewer
      }
    end
  end

  ShowQuery = Client.parse <<-'GRAPHQL'
    query($id: ID!) {
      node(id: $id) {
        ... on Repository {
          id
          owner {
            login
          }
          name
          description
          homepageURL
          hasIssuesEnabled
        }
      }
    }
  GRAPHQL

  def show
    data = query(ShowQuery, id: params[:id])

    if repository = data.node
      render "repositories/show", locals: {
        repository: repository
      }
    else
      head :not_found
    end
  end
end
