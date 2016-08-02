require 'sinatra/base'
require 'jwt'

module JwtDecoder
  class App < Sinatra::Base
    configure :production, :development do
      enable :logging
    end

    configure :test do
      set :logging, Logger::ERROR
    end

    configure :development do
      set :logging, Logger::DEBUG
    end

    configure :production do
      set :logging, Logger::INFO
    end

    get '/' do
      "Hello world!"
    end

    post '/decode' do
      begin
        hmac_secret = 'super_dooper_$ecrets'
        payload = params['token']
        logger.debug "token=#{payload}"

        decoded_data = JWT.decode payload, hmac_secret, true, { :algorithm => 'HS256' }
        logger.debug = "decoded_data=#{decoded_data}"

        "success!"
      rescue
        "failure!"
      end
    end
  end
end
