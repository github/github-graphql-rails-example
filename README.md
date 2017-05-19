# GitHub GraphQL Rails example application

Demonstrates how to use the [`graphql-client`](http://github.com/github/graphql-client) gem to build a simple repository listing web view against the [GitHub GraphQL API](https://developer.github.com/early-access/graphql).

<img width="365" src="https://cloud.githubusercontent.com/assets/137/18425026/a9929d7a-78f0-11e6-9fd4-f478470ad10b.png">

The application structure is setup like a typical Rails app using controllers, views and routes with one key difference, no models. This app doesn't connect directly to any database. All the data is being fetched remotely from the GitHub GraphQL API. Instead of declaring resource models, data queries are declared right along side their usage in controllers and views. This allows an efficient single to be constructed rather than making numerous REST requests to render a single view.

## Table of Contents

Jump right into the code and read the inline documentation. The following is a suggested reading order:

1. [app/controller/repositories_controller.rb](https://github.com/github/github-graphql-rails-example/blob/master/app/controllers/repositories_controller.rb) defines the top level GraphQL queries to fetch repository list and show pages.
2. [app/views/repositories/index.html.erb](https://github.com/github/github-graphql-rails-example/blob/master/app/views/repositories/index.html.erb) shows the root template's listing query and composition over subviews.
3. [app/views/repositories/_repositories.html.erb]( https://github.com/github/github-graphql-rails-example/blob/master/app/views/repositories/_repositories.html.erb) makes use of GraphQL connections to show the first couple items and a "load more" button.
4. [app/views/repositories/show.html.erb](https://github.com/github/github-graphql-rails-example/blob/master/app/views/repositories/show.html.erb) shows the root template for the repository show page.
5.  [app/controller/application_controller.rb](https://github.com/github/github-graphql-rails-example/blob/master/app/controllers/application_controller.rb) defines controller helpers for executing GraphQL query requests.
6. [config/application.rb](https://github.com/github/github-graphql-rails-example/blob/master/config/application.rb) configures `GraphQL::Client` to point to the GitHub GraphQL endpoint.

## Running locally

First, you'll need a [GitHub API access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use) to make GraphQL API requests. This should be set as a `GITHUB_ACCESS_TOKEN` environment variable as configured in [config/secrets.yml](https://github.com/github/github-graphql-rails-example/blob/master/config/secrets.yml).

``` sh
$ git clone https://github.com/github/github-graphql-rails-example
$ cd github-graphql-rails-example/
$ bundle install
$ GITHUB_ACCESS_TOKEN=abc123 bin/rails server
```

And visit [http://localhost:3000/](http://localhost:3000/).

## See Also

* [Facebook's GraphQL homepage](http://graphql.org/)
* [GitHub's GraphQL API Early Access program](https://developer.github.com/early-access/graphql)
* [Ruby GraphQL Client library](https://github.com/github/graphql-client)
* [Relay Modern example](https://github.com/github/github-graphql-relay-example)
