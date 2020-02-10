Rails.application.routes.draw do
  resources :listeneds do
    collection do
      post :search, action: :index
    end
  end
  root 'listeneds#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
