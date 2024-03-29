Rails.application.routes.draw do
  devise_for :users

  get 'reletionships/create'
  get 'reletionships/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root :to =>"homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update]do
    resources :book_comments, only: [:create,:destroy]
    resource :favorites, only: [:create, :destroy]
  end

  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
     get :followings, on: :member
     get :followers, on: :member
     get "daily_posts" => "users#daily_posts"
  end

  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show]

  get "search" => "searches#search",as: "search"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
