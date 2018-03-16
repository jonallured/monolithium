Rails.application.routes.draw do
  get 'faring_direball', to: 'faring_direball#index'
  root to: 'static#root'
end
