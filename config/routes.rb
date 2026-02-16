Rails.application.routes.draw do
  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks' 
  }
  resources :contacts
  resources :posts
  resources :users, only: [:index, :show]
  resources :chatrooms, only: [:create, :show] do
    resources :messages, only: [:create]
  end
  
  
  get 'profile', to: 'users#show', as: 'user_profile'
  root "pages#home"
end