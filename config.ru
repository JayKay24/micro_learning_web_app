require 'sinatra/base'
require './models/user'
require './app/controllers/application_controller'
require './app/controllers/category_controller'
require './app/controllers/user_controller'
require './app/controllers/link_controller'
require './app/controllers/setting_controller'
require 'rack'

use SettingController
use LinkController
use CategoryController
use UserController

run ApplicationController
