require "github"

class RepositoriesController < ApplicationController
  def index
    data = GitHub.fetch <<-'GRAPHQL'
      query {
        viewer {
          repositories {
            edges {
              node {
                id
                owner {
                  login
                }
                name
              }
            }
          }
        }
      }
    GRAPHQL

    render "repositories/index", locals: {
      viewer: data["viewer"]
    }
  end

  def show
    data = GitHub.fetch <<-'GRAPHQL', id: params[:id]
      query($id: ID!) {
        node(id: $id) {
          ... on Repository {
            id
            owner {
              login
            }
            name
            stars {
              totalCount
            }
          }
        }
      }
    GRAPHQL

    if repository = data["node"]
      render "repositories/show", locals: {
        repository: data["node"]
      }
    else
      head :not_found
    end
  end
end
