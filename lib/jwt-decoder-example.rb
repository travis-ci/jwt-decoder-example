require 'sinatra/base'
require 'jwt'

module JwtDecoder
  class App < Sinatra::Base
    configure :production, :development do
      enable :logging
    end

    get '/' do
      "Hello world!"
    end
  end
end
