require './config/environment'



use Rack::MethodOverride
use UsersController
use PlantsController
run ApplicationController
