# frozen_string_literal: true

module SessionSupport
  extend ActiveSupport::Concern
  ACCESS_KEY = 'X-Access-Key'

  included do
    helpers do
      include Sorcery::Controller

      # Remove duplicate modules
      %w[before_logout after_logout after_login after_failed_login].each do |method|
        Sorcery::Controller::Config.send "#{method}=", Sorcery::Controller::Config.send(method).uniq
      end

      def session
        if Rails.env.test?
          @_session ||= request.session # Useful for testing
        else
          env[Rack::RACK_SESSION]
        end
      end

      def remote_ip
        request.ip
      end

      def authorize_user!
        # request.path.ends_with? 'swagger_doc'
        raise ApiError::NotAuthenticated unless logged_in?
      end

      # Disable remember_me because of the cookies type conflict
      def current_user
        @current_user = login_from_access_key || login_from_session || nil unless defined?(@current_user)
        @current_user
      end

      def access_key
        headers[ACCESS_KEY]
      end

      def login_from_access_key
        return if access_key.blank?

        User.find_by(access_key: access_key) || raise(ApiError::InvalidAccessKey)
      end

      ## ActionDispatch::Request
      #
      def reset_session
        if session&.respond_to?(:destroy)
          session.destroy
        else
          self.session = {}
        end
        @env['action_dispatch.request.flash_hash'] = nil
      end
    end
  end
end
