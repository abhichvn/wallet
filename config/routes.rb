Rails.application.routes.draw do
  get 'report/index'

  resources :bills, only: [:index, :new, :create, :show]
  root "bills#index"
end
