Rails.application.routes.draw do
  resources :projects, only: %i[create index update]
  get 'faring_direball', to: 'faring_direball#index'
  get :entries, to: 'entries#index'
  get :hooks, to: 'hooks#index'
  post :hooks, to: 'hooks#create'

  get 'sign_in', to: 'password#new', as: :sign_in
  post 'sign_in', to: 'password#create'
  get 'sign_out', to: 'password#clear', as: :sign_out

  scope :api do
    scope :v1 do
      get 'work_weeks/:year/:number', to: 'work_weeks#show'
      patch 'work_days/:id', to: 'work_days#update'
      get :pto_reports, to: 'pto_reports#index'

      get :entries, to: 'api/v1/entries#index'
      post :entries, to: 'api/v1/entries#update'
    end
  end

  root to: 'static#root'
end
