Rails.application.routes.draw do
  resources :repositories do
    get "more", on: :collection
    put "star", on: :member
    put "unstar", on: :member
  end
  get "/", to: redirect("/repositories")
end
