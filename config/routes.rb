Rails.application.routes.draw do

  localized do
    devise_for :administrators, path: :admin
    devise_for :teachers, path: :teacher, controllers: { registrations: 'devise/custom_registrations' }
    devise_for :students, path: :student, controllers: { registrations: 'devise/custom_registrations' }

    namespace :admin do
      resource :profile, only: [:edit, :update]
      resources :administrators, :subjects, :classrooms
      resources :teachers, only: [:index, :show, :edit, :update, :destroy]
      resources :students, only: [:index, :show, :edit, :update]
      root 'home#index'
    end

    namespace :teacher do
      resource :profile, :classrooms_and_subjects, only: [:edit, :update]
      resources :students, only: [:index, :show, :edit, :update]
      resources :questionnaires do
        patch :publish, on: :member
      end

      root 'home#index'
    end

    scope module: :student do
      resource :profile, only: [:edit, :update], as: :student_profile
      resources :answered_questionnaires, only: [:update]
      resources :questionnaires, only: [:index, :show, :update] do
        get :answer, on: :member
      end

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
