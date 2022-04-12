Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: %i[create destroy edit update] do
      member do
        put :mark_as_best
      end
    end
  end
end
