# frozen_string_literal: true

class SwaggerController < ::ApplicationController
  layout 'swagger'

  # https://github.com/yunixon/swagger-ui_rails5/blob/master/app/views/swagger_ui/_swagger_ui.html.erb
  def index
    render locals: {
      title: 'Tasky API',
      discovery_url: request.path + '/v1/swagger_doc'
    }
  end
end
