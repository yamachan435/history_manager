Rails.application.routes.draw do
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
