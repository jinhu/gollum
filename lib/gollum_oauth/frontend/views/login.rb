module Precious
  module Views
    class Login < Layout
      attr_accessor :session, :client, :request, :service_name

      def authorize_url
        #client.web_server.authorize_url(
            client.authorize_url(
          :redirect_uri => "#{request.scheme}://#{request.host}:#{request.port}/auth",
          :response_type => 'code',
          :scope => 'read'
        )
      end
    end
  end
end
