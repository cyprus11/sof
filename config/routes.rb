Rails.application.routes.draw do
  root to: 'questions#index'

  resources :questions do
    resources :answers, only: %i[new create]
  end
end
