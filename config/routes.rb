Rails.application.routes.draw do

  #localized do
  root 'home#index'
  #end

  scope :api do
    resources :cep, only: [:show]
  end
end
