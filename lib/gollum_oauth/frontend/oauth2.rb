require 'oauth2'
require 'json'

module Precious
  module OAuth
    
    def self.config=(conf)
      @config = conf
    end
    
    def self.config
      @config || raise('Please configure oauth using Precious::OAuth.config = {:service_name => \'...\', :client_id => \'...\', :client_secret => \'...\', :site => \'http://www.example.com\', :scope => \'...\'}')
    end
    
    def self.included(base)
      base.class_eval do
        
        # for the user auth thing
        enable :sessions
        
        get '/login' do
          @service_name = oauth_config[:service_name]
          @request = request
          @session = session
          @oauth_client = oauth_client
          mustache :login
        end

        get '/auth' do
          access_token = oauth_client.web_server.get_access_token(params[:code], :grant_type => 'authorization_code')
          user = get_user_details(access_token)
          session['name'] = user['login']
          session['email'] = user['email']
          redirect '/'
        end

        get '/logout' do
          session['email'] = session['name'] = nil
          redirect '/'
        end
      end
    end
    
    def get_user_details(access_token)
      JSON.parse(access_token.get("#{oauth_server_url}/api/user"))
    end
    
    def oauth_client
      @client ||= ::OAuth2::Client.new(
        oauth_config[:client_id],
        oauth_config[:client_secret],
        :site => oauth_server_url,
        :scope => oauth_config[:scope],
        :authorize_path => oauth_config[:authorize_path],
        :access_token_path => oauth_config[:access_token_path]
      )
    end
    
    def oauth_server_url
      oauth_config[:site]
    end
    
    def oauth_config
      Precious::OAuth.config
    end
    
    def get_auth_user
      return nil if !session['email']
      return { :email => session['email'], :name => session['fullname'] }
    end
  end
end