Rails.application.routes.draw do
  localized do
    devise_for :administrators, path: :admin

    namespace :admin do
      resources :administrators
      root 'home#index', as: :root
    end

    namespace :teacher do
      root 'home#index', as: :root
    end

    namespace :student do
      root 'home#index', as: :root
    end
  end


  namespace :api do
    namespace :v1 do
      resources :cep, only: [:show]
    end
  end

  root 'admin/home#index'
end
