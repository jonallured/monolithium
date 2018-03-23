Rails.application.routes.draw do
  resources :projects, only: %i[create index update]
  get 'faring_direball', to: 'faring_direball#index'
  root to: 'static#root'
end
