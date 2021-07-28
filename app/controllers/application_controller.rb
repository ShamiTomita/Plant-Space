require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "aloe_you_vera_much"
  end

  get "/" do
    erb :index
  end
  helpers do
     def logged_in?
       !!current_user
     end

     def current_user
       @current_user ||= User.find(session[:user_id]) if session[:user_id]
     end

     def authentication_required
       if !logged_in?
         flash[:notice] = "You must be logged in."
         redirect '/'
       end
     end
   end



 end
