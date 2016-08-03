require 'sinatra/base'
require 'jwt'
require 'logger'

module JwtDecoder
  class App < Sinatra::Base
    configure :production, :development do
      enable :logging
    end

    configure :test do
      set :logging, ::Logger::ERROR
    end

    configure :development do
      set :logging, ::Logger::DEBUG
    end

    configure :production do
      set :logging, ::Logger::INFO
    end

    get '/' do
      "Hello world!"
    end

    post '/decode' do
      begin
        hmac_secret = ENV['JWT_SECRET']
        payload = JSON.parse(request.body.read)
        token   = payload['token']
        logger.debug "token=#{token}"

        decoded_data = JWT.decode token, hmac_secret, true, { :algorithm => 'HS256' }
        logger.debug = "decoded_data=#{decoded_data}"

        "success!"
      rescue => e
        logger.debug e.backtrace.join("\n")

        status 500
        "failure!"
      end
    end
  end
end
