Rails.application.routes.draw do
  resources :repositories do
    get "more", on: :collection
  end
  get "/", to: redirect("/repositories")
end
