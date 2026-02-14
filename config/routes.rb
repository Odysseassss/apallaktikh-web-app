Rails.application.routes.draw do
  resources :contacts
  resources :posts
  resources :chatrooms, only: [:create, :show] do
    resources :messages, only: [:create]
  end
  
  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks' 
  }
  get 'profile', to: 'users#show', as: 'user_profile'
  root "pages#home"
end