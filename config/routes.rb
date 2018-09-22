Rails.application.routes.draw do
  resources :projects, only: %i[create index update]
  get 'faring_direball', to: 'faring_direball#index'
  get :entries, to: 'entries#index'
  get :hooks, to: 'hooks#index'
  post :hooks, to: 'hooks#create'
  get :artsy_pull_requests, to: 'artsy_pull_requests#index'

  get 'sign_in', to: 'password#new', as: :sign_in
  post 'sign_in', to: 'password#create'
  get 'sign_out', to: 'password#clear', as: :sign_out

  namespace :rando, module: :rando_pool do
    get '/seasons', to: 'seasons#index', as: :seasons
    get '/seasons/:season_name', to: 'seasons#show', as: :season
    get '/seasons/:season_name/weeks/:week_number', to: 'weeks#show', as: :season_week
    get '/seasons/:season_name/characters/:character_id', to: 'characters#show', as: :season_character
  end

  get '/rando/stats', to: 'static#rando_stats'
  get '/rando', to: 'static#rando_home'

  namespace :api do
    namespace :v1 do
      get :entries, to: 'entries#index'
      post :entries, to: 'entries#update'

      get 'work_weeks/:year/:number', to: 'work_weeks#show'
      patch 'work_days/:id', to: 'work_days#update'
      get :pto_reports, to: 'pto_reports#index'

      get :teams, to: 'teams#index'
    end
  end

  scope :api do
    scope :v1 do
      namespace :current_season, module: 'api/current_season' do
        get :characters, to: 'characters#index'
        get :rando_picks, to: 'rando_picks#index'
        post :rando_picks, to: 'rando_picks#create'
        get 'weeks/:week_number/active_teams', to: 'active_teams#index'
        post :picks, to: 'picks#create'
      end
    end
  end

  root to: 'static#root'
end
