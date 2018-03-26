Rails.application.routes.draw do
  resources :projects, only: %i[create index update]
  get 'faring_direball', to: 'faring_direball#index'

  get 'sign_in', to: 'password#new', as: :sign_in
  post 'sign_in', to: 'password#create'
  get 'sign_out', to: 'password#clear', as: :sign_out

  root to: 'static#root'
end
