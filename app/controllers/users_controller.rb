require 'pry'
require 'rack-flash'
class UsersController < ApplicationController
  use Rack::Flash

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
        flash[:notice] = "Thanks for signing up! Please Create your first plant to get started"
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
      flash[:notice] = "Logged in!"
      redirect to '/plants'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:notice] = "Welcome back #{user.username}!"
        redirect to '/plants'
      else
        flash[:notice] = "Please Sign up!"
        redirect to '/signup'
      end
    end

  get '/logout' do
    if logged_in?
      session.destroy
      flash[:notice] = "You're Logged Out!"
      redirect to 'login'
    else
      redirect to '/'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

  get '/users/:slug/edit' do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      if @user == current_user
        erb:'/users/edit_user'
      else
        redirect to '/plants'
      end
    else
      redirect to '/login'
    end
  end

  patch '/users/:slug' do
    if logged_in?
        @user = User.find_by_slug(params[:slug])
        if @user == current_user
          if @user.update(username: params[:username], email: params[:email], password: params[:password])
            current_user.plants == @user.plants
            @user.save
            redirect to ("/plants/plants")
          else
            redirect to ("/users/:slug/edit")
          end
        else
          redirect to "/users/:slug/edit"
        end
    else
      redirect to '/login'
    end
  end


end
