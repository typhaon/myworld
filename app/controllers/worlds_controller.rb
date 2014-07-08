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
    @world = World.new(world_params)
    if @world.save

      row = 0
      column = 0
      terrain_id = 1
      world_id = World.last.id
      max_rows = world_params[:max_rows].to_i
      max_columns = world_params[:max_columns].to_i


      #Create Method?  Where?

      until row == max_rows && column == 0
        @cell = Cell.create(row: row, column: column, terrain_id: terrain_id, world_id: world_id)

        if Cell.last.terrain_id == 1
          terrain_id = rand(3)
        elsif Cell.last.terrain_id == 2
          terrain_id = rand(3) + 1
        elsif Cell.last.terrain_id == 3
          terrain_id = rand(2) + 2
        end

        if terrain_id == 0
          terrain_id = 1
        end

        if column == max_columns - 1
          row = row + 1
          column = 0
        else
          column = column + 1
        end

      end
    redirect_to worlds_path
    elsif
      render :new
    end
  end






  private

  def world_params
    params.require(:world).permit(:name, :max_rows, :max_columns)
  end
end
