require 'sinatra/base'
require './app/controllers/application_controller'
require './app/controllers/user_controller'

# Map the controllers to the routes
map('/users') { run UserController }
map('/submit') { run UserController }
map('/') { run ApplicationController }
