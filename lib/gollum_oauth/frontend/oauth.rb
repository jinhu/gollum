require 'oauth'
require 'json'

module Precious
  module OAuth
    
    def self.config=(conf)
      @config = conf
    end
    
    def self.config
      @config || raise('Please configure oauth using Precious::OAuth.config = {:service_name => \'...\', :consumer_key => \'...\', :consumer_secret => \'...\', :server_url => \'http://www.example.com\'}')
    end
    
    def self.included(base)
      base.class_eval do
        
        # for the user auth thing
        enable :sessions
        
        get '/login' do
          @service_name = oauth_config[:service_name]
          @request = request
          @session = session
          @oauth_consumer = oauth_consumer
          mustache :login
        end

        get '/auth' do
          access_token = session[:request_token].get_access_token oauth_token: params['oauth_token'], oauth_verifier: params['oauth_verifier']
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
      JSON.parse(access_token.get("#{oauth_server_url}/api/user").body)
    end
    
    def oauth_consumer
      @consumer ||= ::OAuth::Consumer.new(
        oauth_config[:consumer_key],
        oauth_config[:consumer_secret],
        site: oauth_server_url)
    end
    
    def oauth_server_url
      oauth_config[:server_url]
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