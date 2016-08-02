require 'sinatra/base'
require 'jwt'

module JwtDecoder
  class App < Sinatra::Base

    get '/' do
      "Hello world!"
    end
  end
end
