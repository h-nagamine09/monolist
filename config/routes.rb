Rails.application.routes.draw do
  root to: 'toppages#index'
  
   get 'login',to: 'sessions#new'
   post 'login', to: 'sessions#create'
   delete 'logout',to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
 
  resources :users, only: [:show, :new, :create]
  
  resources :items, only: [:new] #楽天APIを使った検索結果を表示するページのみ作成
end
