require 'pry'
require 'rack-flash'
class UsersController < ApplicationController
  use Rack::Flash

  get '/signup' do
    if !logged_in?
      erb :'users/create_user'
    else
      redirect to '/garden'
    end
  end

  post '/signup' do
    if params[:username] != "" && params[:password] != "" && params[:email] != "" && params[:username] && params[:username]
      @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Thanks for signing up! Please name your garden and then create your first plant to get started"
        redirect to '/garden'
    else
      redirect to '/signup'
    end
  end

  get '/login' do
    if !logged_in?
      flash[:notice] = "Please Fill In Data Correctly Again"
      redirect to '/signup'
    else
      flash[:notice] = "Logged in!"
      redirect to '/garden'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:notice] = "Welcome back #{user.username}!"
        redirect to '/garden'
      else
        flash[:notice] = "Please Sign up!"
        redirect to '/signup'
      end
    end

  get '/logout' do
    if logged_in?
      session.destroy
      session[:user_id] = nil
      flash[:notice] = "You're Logged Out!"
      redirect to '/'
    else
      redirect to '/'
    end
  end


end
