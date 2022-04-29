Rails.application.routes.draw do
  concern :votable do
    post :vote
    delete :unvote
  end

  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: %i[create destroy edit update] do
      member do
        put :mark_as_best
        concerns :votable
      end
    end
  end

  resources :files, only: :destroy
  resources :rewards, only: :index
end
