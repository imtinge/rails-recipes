Rails.application.routes.draw do
   require 'sidekiq/web'
   authenticate :user, lambda { |u| u.is_admin? } do
     mount Sidekiq::Web => '/sidekiq'
   end
  devise_for :users
  resource :user


  resources :events do
    resources :registrations do
      member do
        get 'steps/1', to: 'registrations#step1', as: :step1
        patch 'steps/1/update', to: 'registrations#step1_update', as: :update_step1
        get 'steps/2', to: 'registrations#step2', as: :step2
        patch 'steps/2/update', to: 'registrations#step2_update', as: :update_step2
        get 'steps/3', to: 'registrations#step3', as: :step3
        patch 'steps/3/update', to: 'registrations#step3_update', as: :update_step3
      end
    end
  end

  namespace :admin do
    root "events#index"
    resources :versions do
      post :undo
    end
    resources :events do
      resources :registration_imports
      resources :registrations, :controller => "event_registrations" do
        collection do
          post :import
        end
      end
      resources :tickets, controller: 'event_tickets'
      member do
        post :reorder
      end
      collection do
        post :bulk_update
      end
    end
    resources :users do
      resource :profile, controller: 'user_profiles'
    end
  end

  get '/faq', to: 'pages#faq'

  root "events#index"

end
