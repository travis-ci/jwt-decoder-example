require 'sinatra/base'
require 'jwt'
require 'logger'

module JwtDecoder
  class App < Sinatra::Base
    ISSUER = 'Travis CI, GmbH'

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
        # instead of ENV, the app would want to look up the secret for this payload
        # by another means, say by payload['key_id'], which can be public wihout
        # breach of security.
        hmac_secret  = ENV.fetch('JWT_SECRET', '')
        payload      = JSON.parse(request.body.read)
        token        = payload.fetch('token', '')
        logger.debug "token=#{token}"

        # in addition, the app may choose to verify various claims of this token,
        # such as 'iat' (token issue time), 'exp' (token expiration time)
        # See https://github.com/jwt/ruby-jwt#support-for-reserved-claim-namess
        # if the claims *are* verified, it is best to communicate this with the user
        decoded_data = JWT.decode token, hmac_secret, true, {
          :iss => ISSUER, :verify_iss => true, :verify_iat => true, :algorithm => 'HS256'
        }

        # Do stuff with decoded_data
        # decoded_data[0] is the payload
        logger.debug "decoded_data=#{decoded_data[0]}"

        "success!"
      rescue => e
        logger.debug e.backtrace.join("\n")

        status 500
        "failure!"
      end
    end
  end
end
