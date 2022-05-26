Rails.application.routes.draw do
  concern :votable do
    post :vote
    delete :unvote
  end

  concern :commentable do
    get :new_comment
    post :create_comment
  end

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', registrations: 'confirmations/registrations', confirmations: 'confirmations/confirmations' }
  root to: 'questions#index'

  resources :questions do
    member do
      concerns :commentable
    end

    resources :answers, shallow: true, only: %i[create destroy edit update] do
      member do
        put :mark_as_best
        concerns :votable
        concerns :commentable
      end
    end
  end

  resources :files, only: :destroy
  resources :rewards, only: :index
end
