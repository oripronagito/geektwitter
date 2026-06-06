Rails.application.routes.draw do
  devise_for :users
  resources :users,only: [:show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  get 'tweets/:tweet_id/likes' => 'likes#create'
  get 'tweets/:tweet_id/likes/:id' => 'likes#destroy'
  #tweetコントローラーの追加
  patch 'tweets/:id' => 'tweets#update'
  resources :tweets do
    resources :likes, only: [:create, :destroy]
    #commentコントローラーの追加
    resources :comments, only: [:create]
  end
  delete 'tweets/:id' => 'tweets#destroy'
  get 'tweets/:id/edit' =>'tweets#edit'
  resources :tags do
    get 'tweets' => 'tweets#search'
  end

  root 'hello#index'

end
