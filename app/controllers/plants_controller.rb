class PlantsController < ApplicationController

  get '/plants' do
    if logged_in?
      @plants = Plant.all

      erb :'plants/plants'
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
        @plant = current_user.plants.build(name: params[:name], character: params[:character])

        @plant.save
        redirect to "/plants/#{@plant.id}"
      else
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
      if @plant && @plant.user == current_user
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
      if @plant && @plant.user == current_user
        @plant.delete
      end
      redirect to '/plants/plants'
    else
      redirectto '/login'
      end
  end


  patch '/plants/:id' do
    if logged_in?
      if params[:character] == "" && params[:name] != ""
        redirect to ("/plants/#{params[:id]}/edit")
      else
        @plant = Plant.find_by_id(params[:id])
        if @plant && @plant.user == current_user
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
