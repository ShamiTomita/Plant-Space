class PlantsController < ApplicationController

  get '/plants' do
    if logged_in?
      if !current_user.garden.plants.empty?
        @plants = current_user.plants.all
        puts "hi"
        erb :'plants/plants'
      else
        erb :'plants/create_plant'
      end
    else
      redirect to '/login'
    end

  end

  get '/plants/new' do
    if logged_in?
      erb :'plants/create_plant'
    else
      redirect to '/login'
    end
  end

  post '/plants' do
    if logged_in?
      if params[:character] != "" && params[:name] != ""
        @plant = current_user.garden.plants.build(name: params[:name], garden_id: params[:garden_id], character: params[:character])
        @plant.garden_id = current_user.garden.id
        @plant.save
        redirect to "/garden"
      else
        flash[:notice] = "Warning:Please Fill In All Areas"
        redirect to "plants/new"
      end
    else
      redirect to '/login'
    end
  end

  get '/plants/:id' do
    if logged_in?
      @plant = Plant.find_by_id(params[:id])
      erb :'plants/show_plant'
    else
      redirect to '/login'
    end
  end

  get '/plants/:id/edit' do
    if logged_in?
      @plant = Plant.find_by_id(params[:id])
      if @plant && @plant.garden.user == current_user
      erb:'/plants/edit_plant'
    else
      redirect to '/plants'
    end
    else
      redirect to '/login'
    end
  end

  delete '/plants/:id/delete' do
    if logged_in?
      @plant = Plant.find_by_id(params[:id])
      if @plant && @plant.garden.user == current_user
        @plant.delete
      end
        redirect to '/garden'
        flash[:notice] = "Plant deleted"
    else
      redirect to '/login'
    end
  end


  patch '/plants/:id' do
    if logged_in?
      if params[:character] == "" && params[:name] != ""
        redirect to ("/plants/#{params[:id]}/edit")
      else
        @plant = Plant.find_by_id(params[:id])
        if @plant && @plant.garden.user == current_user
          if @plant.update(name: params[:name], character: params[:character])
            redirect to ("/plants/#{@plant.id}")
          else
            redirect to ("/plants/#{params[:id]}/edit")
          end
        else
          redirect to "/plants/#{@plant.id}/edit"
        end
      end
    else
      redirect to '/login'
    end
  end




end
