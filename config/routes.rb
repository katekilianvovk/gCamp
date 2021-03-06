Rails.application.routes.draw do

  root 'welcome#index'

  get '/about', to: 'about#index'

  get '/terms', to: 'terms#index'

  get '/faq', to: 'common_questions#index'

  get 'sign-up', to: 'registrations#new', as: 'sign-up'

  post "sign-up", to: "registrations#create"

  get 'sign-in', to: "authentication#new"

  post 'sign-in', to: "authentication#create"

  get 'sign-out', to: 'authentication#destroy'

  resources :users

  resources :projects do
    resources :tasks
    resources :memberships, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  resources :tasks do
    resources :comments, only: [:new, :create]
  end

  resources :trackers, only: [:show]

end
