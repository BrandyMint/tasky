# frozen_string_literal: true

class Account::API < Grape::API
  default_format :json
  version 'v1'

  include ErrorHandlers
  include SessionSupport
  include ApiHelpers

  mount Account::InvitesAPI
  mount Account::BoardsAPI
  mount Account::BoardMembershipsAPI
  mount Account::LanesAPI
  mount Account::TasksAPI
  mount Account::CardsAPI
  mount Account::TaskCommentsAPI

  helpers do
    include CurrentAccount
  end

  before do
    authorize_user!
  end

  add_swagger_documentation(
    array_use_braces: true,
    doc_version: '0.1.3',
    info: {
      title: 'Tasky Account API',
      description: 'API аккаунтов (команд). Стандарты: https://jsonapi.org'
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
