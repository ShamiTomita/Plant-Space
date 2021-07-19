ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'
require 'sinatra/activerecord'

task :console do
  Pry.start
end
