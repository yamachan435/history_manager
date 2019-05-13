Rails.application.routes.draw do
  root 'toppages#index'
  resources :histories do
    post 'bulk_create', on: :collection
    post 'link', on: :member
    put 'unlink', on: :member
  end
  get 'top' => 'toppages#top'
  get 'callback' => 'toppages#callback'
  get 'login' => 'toppages#login'
  get 'money' => 'toppages#money'
end
