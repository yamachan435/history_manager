Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'   
  } 

  devise_scope :user do
    get "sign_in", :to => "users/sessions#new"
    get "sign_out", :to => "users/sessions#destroy" 
  end
  resources :users
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
  namespace 'api' do
    namespace 'v1' do
      namespace 'user' do
        post 'bulk_create_histories'
      end
    end
  end
end
