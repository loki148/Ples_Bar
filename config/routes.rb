Rails.application.routes.draw do
  # get 'stats/index'
  resources :orders, only: [:new, :create, :index, :destroy] do
    member do
      post 'ready'
      post 'deliver'
      post 'rollback'
    end
  end

  get "/stats", to: "stats#index"
  get "/stats/reset", to: "stats#del"
  resource :stats, only: [:index] do
  post :reset
end
  get '/public', to: 'orders#public_index'
  get '/spotlight', to: 'pages#spotlight'
  post 'spotlight', to: 'orders#spotlight'

  root "pages#home"
end
