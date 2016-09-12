# GitHub GraphQL Rails example application

Demonstrates how to use the [`graphql-client gem`](http://github.com/github/graphql-client) to build a Rails web view against the [GitHub GraphQL API](https://developer.github.com/).

## Setup

First, you'll need a [GitHub API access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use) to make GraphQL API requests. This should be set as a `GITHUB_ACCESS_TOKEN` environment variable as configured in [config/secrets.yml](https://github.com/github/github-graphql-rails-example/blob/master/config/secrets.yml).

``` sh
$ git clone https://github.com/github/github-graphql-rails-example
$ cd github-graphql-rails-example/
$ bundle install
$ GITHUB_ACCESS_TOKEN=abc123 bin/rails
```

And visit [http://localhost:3000/](http://localhost:3000/).

## Table of Contents

* [app/controller/repositories_controller.rb](https://github.com/github/github-graphql-rails-example/blob/master/app/controllers/repositories_controller.rb) defines GraphQL queries to fetch repository list and show pages.
* [app/controller/application_controller.rb](https://github.com/github/github-graphql-rails-example/blob/master/app/controllers/application_controller.rb) configures `GraphQL::Client` and defines controller helpers for executing GraphQL query requests.
* [lib/github.rb](https://github.com/github/github-graphql-rails-example/blob/master/lib/github.rb) defines a simple `Net::HTTP` based network adapter for performing queries. A production application would likely use a more sophisticated network stack.
* [lib/tasks/schema.rake](https://github.com/github/github-graphql-rails-example/blob/master/lib/tasks/schema.rake) defines `rake schema:update` task to fetch the latest GraphQL GraphQL schema.
