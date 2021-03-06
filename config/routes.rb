Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :products, only: [:show, :new, :create, :edit] do
    get '/scan-labels', to: 'scans#text_recognition'
    get '/result', to: 'scans#result', as: :label_result
  end

  patch '/products/:id', to: 'products#update'
  put '/products/:id', to: 'products#bookmark', as: :bookmark

  resources :users, only: [:show, :edit, :update] do
    resources :histories, only: [:index]
  end

  resources :restrictions, only: [:new, :create]

  get '/scan-barcodes', to: 'scans#new'
  post '/scan-barcodes', to: 'scans#create'

end
