# frozen_string_literal: true

Rails.application.routes.draw do
  default_url_options Settings.default_url_options.symbolize_keys

  scope subdomain: '', constraints: { subdomain: '' } do
    root to: 'welcome#index'

    resources :sessions, only: %i[new create] do
      collection do
        delete :destroy
      end
    end
    resource :user, only: %i[edit update], controller: :user

    resources :boards
  end

  scope subdomain: 'api', as: :api, constraints: { subdomain: 'api' } do
    root controller: :swagger, action: :index, as: :doc # , constraints: { format: :html }
    mount Public::API => '/'
  end
end
