Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"

  get "analytics/:metric/:mode/:year/:month", to: "analytics_reports#show", as: :analytics_report
  get "artsy-viewer", to: "artsy_viewer#show"
  get "crank-champ/leaderboard", to: "crank_champ/leaderboard#index"
  get "cybertail", to: "cybertail#index"
  get "dashboard", to: "dashboard#show"
  get "decode-jwt", to: "decode_jwt#show"
  get "faring_direball", to: "faring_direball#index"
  get "financial_reports/:year", to: "financial_reports#show", as: :financial_report
  get "fuzzies", to: "fuzzies#index", as: :fuzzies
  get "model_counts", to: "model_counts#index", as: :model_counts
  get "post_bin", to: "post_bin#index"
  get "reading-list/:year", to: "reading_list#index", as: :reading_list
  get "sneakers", to: "sneakers#index", as: :sneakers
  get "today", to: "today#show", as: :today
  get "wishlist", to: "wishlist#index"
  get "work_weeks/:target", to: "work_weeks#show", as: :work_week

  get "project_list", to: "project_list#index", as: :project_list
  patch "project_list/:id", to: "project_list#update"

  get "vanishing-box", to: "vanishing_box#show"
  post "vanishing-box", to: "vanishing_box#create"

  scope :style do
    get :article, to: "static#article", as: "article_styles"
    get :color, to: "static#color", as: "color_styles"
    get :flashes, to: "static#flashes", as: "flashes_styles"
    get :form, to: "static#form", as: "form_styles"
    get :table, to: "static#table", as: "table_styles"
  end

  get "sign_in", to: "password#new", as: :sign_in
  post "sign_in", to: "password#create"
  get "sign_out", to: "password#clear", as: :sign_out

  resources :gift_ideas, only: %i[update]

  resources :crank_users, only: %i[create new show], param: :code do
    resources :crank_counts, only: %i[create new show]
  end

  namespace :crud do
    resources :things
    resources :apache_log_files
    resources :books
    resources :csv_uploads
    resources :financial_accounts do
      resources :financial_statements
    end
    resources :gift_ideas
    resources :post_bin_requests
    resources :projects
    resources :raw_hooks
    resources :sneakers
    resources :warm_fuzzies
    resources :webhook_senders
  end

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :books, only: %i[index show create update destroy]
      resources :work_days, only: %i[index show create update destroy]

      get :decode_jwt, to: "decode_jwt#show"
      get :ping, to: "ping#show"
      post :post_bin, to: "post_bin#create"
      post :raw_hooks, to: "raw_hooks#create"
      post :vanishing_messages, to: "vanishing_messages#create"

      namespace :word_rot do
        get :killswitch, to: "killswitch#show"
      end
    end
  end

  root to: "static#root"
end
