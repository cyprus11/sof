require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  concern :votable do
    post :vote
    delete :unvote
  end

  concern :commentable do
    get :new_comment
    post :create_comment
  end

  concern :subscriptionable do
    post :subscribe
    delete :unsubscribe
  end

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', registrations: 'confirmations/registrations', confirmations: 'confirmations/confirmations' }
  root to: 'questions#index'

  resources :questions do
    member do
      concerns %i[commentable subscriptionable]
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

  namespace :api do
    namespace :v1 do
      defaults format: :json do
        resources :profiles, only: [:index] do
          get :me, on: :collection
        end

        resources :questions, only: %i[index show create update destroy] do
          resources :answers, shallow: true, only: %i[index show create update destroy]
        end
      end
    end
  end
end
