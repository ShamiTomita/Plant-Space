class GardenController < ApplicationController

  get '/garden' do
    if logged_in?
      if current_user.garden == nil
        erb :'garden/create_garden'
      elsif current_user.garden != nil && current_user.garden.plants.empty?
        redirect to '/plants/create_plant'
      else
        @garden = current_user.garden
        @plants = current_user.garden.plants.all
        erb :'garden/show_garden'
      end
    else
      redirect to '/login'
    end

  end

  get 'garden/new' do
    if logged_in? && user.garden == nil
      erb :'garden/create_garden'
    else
      redirect to '/login'
    end
  end

  post '/garden' do
    if logged_in?
      if params[:name] != ""
        @garden = Garden.create(:name => params[:name], :user_id => params[:user_id])
        @garden.user_id = current_user.id
        @garden.save
        if @garden.plants.empty?
          erb :'plants/create_plant'
        else
          erb :'garden/show_garden'
        end
      else
        redirect to '/garden/new'
      end
    else
      redirect to '/login'
    end
  end

#  get '/garden/:id' do
#    if logged_in?
#      @garden = Garden.find_by_id(params[:id])
#      erb :'garden/show_garden'
#    else
#      redirect to '/login'
#    end
#  end

  get '/garden/:id/edit' do
    if logged_in?
      @garden = Garden.find_by_id(params[:id])
      if @garden && @garden.user == current_user
      erb:'/garden/edit_garden'
    else
      redirect to '/plants'
    end
    else
      redirect to '/login'
    end
  end

  delete '/garden/:id/delete' do
    if logged_in?
      @garden = Garden.find_by_id(params[:id])
      if @garden && @garden.user == current_user
        @garden.delete
      end
        redirect to '/garden/new'
        flash[:notice] = "Garden deleted"
    else
      redirect to '/login'
    end
  end


#  patch '/plants/:id' do
#    if logged_in?
#      if params[:name] == ""
#        redirect to ("/garden/#{params[:id]}/edit")
#      else
#        @garden = Garden.find_by_id(params[:id])
#        if @garden && @garden.user == current_user
#          if @garden.update(name: params[:name])
#            redirect to ("/garden/#{@garden.id}")
#          else
#            redirect to ("/garden/#{params[:id]}/edit")
#          end
#        else
#          redirect to "/garden/#{@garden.id}/edit"
#        end
#      end
#    else
#      redirect to '/login'
#    end
#  end
#



end
