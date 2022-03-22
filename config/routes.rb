Rails.application.routes.draw do
  resources :questions do
    resources :answers, only: :new
  end
end
