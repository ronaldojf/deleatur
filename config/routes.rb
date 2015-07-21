Rails.application.routes.draw do
  localized do
    devise_for :administrators, path: :admin

    scope :admin, module: :admin do
      resources :administrators
      resources :profile, only: [:edit, :update], as: :admin_profile
      root 'home#index', as: :admin_root
    end

    scope :teacher, module: :teacher do
      root 'home#index', as: :teacher_root
    end

    scope :student, module: :student do
      root 'home#index', as: :student_root
    end
  end


  namespace :api do
    namespace :v1 do
      resources :cep, only: [:show]
    end
  end

  root 'admin/home#index'
end
