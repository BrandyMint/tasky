# frozen_string_literal: true

class RootAPI < Grape::API
  default_format :json
  version 'v1'

  include ErrorHandlers
  include SessionSupport
  include ApiHelpers

  namespace do
    before do
      authorize_user!
    end

    mount Public::UsersAPI
    mount Public::AccountsAPI

    mount InvitesAPI
    mount BoardsAPI
    mount BoardMembershipsAPI
    mount LanesAPI
    mount TasksAPI
    mount CardsAPI
    mount CardMembershipsAPI
  end

  add_swagger_documentation(
    array_use_braces: true,
    doc_version: '0.1.2',
    info: {
      title: 'Tasky API',
      description: 'Spec - https://jsonapi.org'
    },
    security_definitions: {
      api_key: {
        type: 'apiKey',
        name: SessionSupport::ACCESS_KEY,
        in: 'header'
      }
    }
  )
end
