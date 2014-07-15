class WorldsController < ApplicationController

  def index
    @world = World.last
  end

  def show
    @world = World.find(params[:id])
  end

  def new
    @world = World.new
  end

  def create
    @world = WorldBuilder.new(params[:world][:max_rows].to_i, params[:world][:max_columns].to_i)
    @world.generate!
    @world.save(params[:world][:name], params[:world][:max_rows].to_i, params[:world][:max_columns].to_i, params[:world][:id])


    # redirect_to worlds_path

    redirect_to world_path(World.last.id)
  end


  private

  def world_params
    params.require(:world).permit(:name, :max_rows, :max_columns, :cells, :id)
  end
end
