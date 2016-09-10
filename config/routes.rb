Rails.application.routes.draw do
  resources :repositories
  get "/", to: redirect("/repositories")
end
