Rails.application.routes.draw do
  resources :projects, only: %i[create index update]

  get 'artsy-viewer', to: 'artsy_viewer#show'
  get 'faring_direball', to: 'faring_direball#index'

  get :hooks, to: 'hooks#index'
  post :hooks, to: 'hooks#create'
  get :artsy_pull_requests, to: 'artsy_pull_requests#index'

  get 'book-list/:year', to: 'book_list#index'

  get 'sign_in', to: 'password#new', as: :sign_in
  post 'sign_in', to: 'password#create'
  get 'sign_out', to: 'password#clear', as: :sign_out

  namespace :api do
    namespace :v1 do
      get :ping, to: 'ping#show'
    end
  end

  root to: 'static#root'
end
