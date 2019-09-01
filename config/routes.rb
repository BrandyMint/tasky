# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'
require 'route_constraints'

Rails.application.routes.draw do
  default_url_options Settings.default_url_options.symbolize_keys

  concern :archivable do
    member do
      delete :archive
      post :restore
    end
  end

  put :switch_locale, to: 'welcome#switch_locale'
  resource :super_user, only: %i[new create]

  scope subdomain: '', constraints: { subdomain: '' } do
    mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development? || Rails.env.staging?
    get '/sidekiq-stats' => proc { [200, { 'Content-Type' => 'text/plain' }, [Sidekiq::Stats.new.to_json]] }
    Sidekiq::Web.set :session_secret, Rails.application.credentials.secret_key_base
    mount Sidekiq::Web => '/sidekiq' # , constraints: RouteConstraints::AdminRequiredConstraint.new

    root to: 'welcome#index'
    get :developers, to: 'pages#developers'
    resources :invites, only: [] do
      member do
        get :accept
      end
    end
    resources :sessions, only: %i[new create] do
      collection do
        delete :destroy
      end
    end
    resources :users, only: %i[new create]
    resource :profile, only: %i[show update], controller: :profile
    resources :password_resets, only: %i[new create edit update]
    resources :account_memberships, only: %i[destroy new create]

    resources :boards, except: %i[show index]
    resources :accounts

    resources :cards, only: %i[show edit update] do
      concerns :archivable
    end
    resources :invites, controller: :account_invites
    resources :board_memberships, only: [:destroy]
    resources :boards, only: %i[show edit update] do
      member do
        get :users
      end
      concerns :archivable
      resources :members, controller: :board_members
    end
  end

  scope '/api' do
    mount RootAPI => '/'
    root controller: :swagger, action: :index, as: :api_doc # , constraints: { format: :html }
  end

  match '*anything', to: 'application#not_found', via: %i[get post], constraints: { format: :html }
end
