module Precious
  module Views
    class Login < Layout
      attr_accessor :session, :oauth_consumer, :request, :service_name

      def authorize_url
        request_token = oauth_consumer.get_request_token :oauth_callback => "#{request.scheme}://#{request.host}:#{request.port}/auth"
        session[:request_token] = request_token
        request_token.authorize_url
      end
    end
  end
end
