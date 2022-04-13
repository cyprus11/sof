Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    delete 'delete_file/:id', to: 'questions#delete_file', as: 'delete_file'
    resources :answers, shallow: true, only: %i[create destroy edit update] do
      delete 'delete_file/:id', to: 'answers#delete_file', as: 'delete_file'
      member do
        put :mark_as_best
      end
    end
  end
end
