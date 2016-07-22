Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true

  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  config.active_support.deprecation = :log
end
