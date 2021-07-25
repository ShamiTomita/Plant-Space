require 'pry'
class UsersController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :'users/create_user'
    else
      redirect to '/plants'

    end
  end

  post '/signup' do
    if params[:username] != "" && params[:password] != "" && params[:email] != ""
      @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      @user.save
      session[:user_id] = @user.id
      if @user.plants.empty?
        redirect to 'plants/new'
      else
        redirect to 'plants/plants'
      end
    else
      redirect to '/signup'
    end
  end

  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect to '/plants'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect to '/plants'
      else
        redirect to '/signup'
      end
    end

  get '/logout' do
    if logged_in?
      session.destroy
      redirect to 'login'
    else
      redirect to '/'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

end
