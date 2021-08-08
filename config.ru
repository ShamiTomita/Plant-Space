require './config/environment'




use Rack::MethodOverride
use UsersController
use GardenController
use PlantsController
run ApplicationController
