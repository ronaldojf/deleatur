Rails.application.routes.draw do

  localized do
    devise_for :administrators, path: :admin, controllers: { sessions: 'admin/sessions' }
    devise_for :teachers, path: :teacher, controllers: { sessions: 'teacher/sessions' }
    devise_for :students, path: :student, controllers: { sessions: 'student/sessions' }

    namespace :admin do
      resource :profile, only: [:edit, :update]
      resources :administrators, :subjects, :classrooms
      resources :teachers, only: [:index, :show, :update, :destroy]
      resources :students, only: [:index, :show, :edit, :update]
      root 'home#index'
    end

    namespace :teacher do
      resource :profile, only: [:edit, :update]
      root 'home#index'
    end

    scope module: :student do
      resource :profile, only: [:edit, :update], as: :student_profile
      root 'home#index', as: :student_root
    end
  end


  namespace :api do
    namespace :v1 do
      resources :cep, only: [:show]
    end
  end

  root 'student/home#index'
end
