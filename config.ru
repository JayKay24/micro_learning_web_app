require 'sinatra/base'
require './models/user'
require './app/controllers/application_controller'
require './app/controllers/user_controller'

# Map the controllers to the routes
map('/') { run UserController }
