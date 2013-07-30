Myflix::Application.routes.draw do
  root to: 'pages#front'

  resources :videos, only: [:show] do
    collection do
      post :search, as: :search
    end
    resources :reviews, only: [:create]
  end
  get 'videos', to: 'categories#index'
  resources :categories, only: [:show]

  get 'queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'
  resources :queue_items, only: [:create, :destroy]

  namespace :admin do
    resources :videos, only: [:new, :create]
    get '/payments', to: 'payments#index'
  end

  get 'register', to: 'users#new'
  get 'register/:token', to: 'users#new_with_invitation', as: 'register_with_token'
  resources :users, only: [:create, :show]
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]

  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  resources :sessions, only: [:create]

  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired'

  get 'invite', to: 'invitations#new'
  get 'expired_invitation', to: 'invitations#expired'
  resources :invitations, only: [:create]

  mount StripeEvent::Engine => '/stripe-event'

  get 'ui(/:action)', controller: 'ui'
end
