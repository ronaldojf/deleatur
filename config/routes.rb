Rails.application.routes.draw do

  localized do
    devise_for :administrators, path: :admin

    namespace :admin do
      resource :profile, only: [:edit, :update]
      resources :administrators
      resources :subjects
      resources :classrooms
      root 'home#index'
    end

    namespace :teacher do
      root 'home#index'
    end

    namespace :student do
      root 'home#index'
    end
  end


  namespace :api do
    namespace :v1 do
      resources :cep, only: [:show]
    end
  end

  root 'admin/home#index'
end
