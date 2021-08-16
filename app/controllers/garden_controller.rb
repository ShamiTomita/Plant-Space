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
      flash[:notice] = "Please Login"
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
        flash[:notice] = "!!!Please name your garden!!!"
        redirect to '/garden'
      end
    else
      redirect to '/login'
    end
  end

  get '/garden/edit' do
    if logged_in?
      @garden = current_user.garden
      erb:'/garden/edit_garden'
    else
      redirect to '/'
    end
  end



  patch '/garden' do
    if logged_in?
     if params[:name] != ""
       @garden = current_user.garden
        if  @garden.update(name: params[:name])
            @garden.save
            redirect to ("/garden")
        else
         redirect to ("/garden/edit")
        end
     else
      redirect to ("/garden/edit")
      end
    else
      redirect to '/login'
      end
    end


end
