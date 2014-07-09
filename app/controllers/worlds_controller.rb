class WorldsController < ApplicationController

  def index
    @world = World.last
    @cells = Cell.includes(:terrain).includes(:world).where(world_id: @world[:id]).order(:row).order(:column)
    .each_slice(@world.max_columns).to_a
  end

  def new
    @world = World.new
  end

  def create
    @world = WorldBuilder.new(params[:world][:max_rows].to_i, params[:world][:max_columns].to_i)
    @world.generate!
    @world.save(params[:world][:name], params[:world][:max_rows].to_i, params[:world][:max_columns].to_i)
    redirect_to worlds_path
  end


  private

  def world_params
    params.require(:world).permit(:name, :max_rows, :max_columns)
  end
end
