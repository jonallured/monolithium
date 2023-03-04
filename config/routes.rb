Rails.application.routes.draw do
  resources :projects, only: %i[create index update]
  resources :books, only: %i[create edit new update]

  get "artsy-viewer", to: "artsy_viewer#show"
  get "dashboard", to: "dashboard#show"
  get "faring_direball", to: "faring_direball#index"

  get :hooks, to: "hooks#index"
  post :hooks, to: "hooks#create"

  get "book-list/:year", to: "book_list#index"

  get "sign_in", to: "password#new", as: :sign_in
  post "sign_in", to: "password#create"
  get "sign_out", to: "password#clear", as: :sign_out

  namespace :api do
    namespace :v1 do
      get :ping, to: "ping#show"

      namespace :word_rot do
        get :killswitch, to: "killswitch#show"
      end
    end
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
