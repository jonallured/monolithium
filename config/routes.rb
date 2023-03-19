Rails.application.routes.draw do
  get "artsy-viewer", to: "artsy_viewer#show"
  get "cybertail", to: "cybertail#index"
  get "dashboard", to: "dashboard#show"
  get "faring_direball", to: "faring_direball#index"
  get "reading-list/:year", to: "reading_list#index", as: "reading_list"

  get "sign_in", to: "password#new", as: :sign_in
  post "sign_in", to: "password#create"
  get "sign_out", to: "password#clear", as: :sign_out

  namespace :api do
    namespace :v1 do
      get :ping, to: "ping#show"
      post :post_bin, to: "post_bin#create"
      post :raw_hooks, to: "raw_hooks#create"

      namespace :word_rot do
        get :killswitch, to: "killswitch#show"
      end
    end
  end

  namespace :admin do
    resources :books, only: %i[create edit new update]
    resources :gift_ideas
    resources :hooks, only: %i[create edit index]
    resources :projects, only: %i[create index update]
    resources :post_bin_requests, only: %i[index show]
    resources :raw_hooks, only: %i[show]
  end

  scope :style do
    get :article, to: "static#article", as: "article_styles"
    get :color, to: "static#color", as: "color_styles"
    get :flashes, to: "static#flashes", as: "flashes_styles"
    get :form, to: "static#form", as: "form_styles"
    get :table, to: "static#table", as: "table_styles"
  end

  root to: "static#root"
end
