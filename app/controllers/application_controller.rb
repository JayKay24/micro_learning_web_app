require 'sinatra'
require 'sinatra/flash'
require 'warden'
require_relative '../../models/user'

class ApplicationController < Sinatra::Base
  # Set folder for templates to ../views, but make the path absolute
  set views: File.expand_path('../views', __dir__)
  enable :sessions
  set :session_secret, ENV['SHOTGUN_SECRET']
  register Sinatra::Flash
end