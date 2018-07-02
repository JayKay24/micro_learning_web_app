require 'sinatra'

class ApplicationController < Sinatra::Base
  # Set folder for templates to ../views, but make the path absolute
  # set views: File.expand_path('../../views', __dir__)
  set views: File.expand_path('../views', __dir__)
end