class WorldsController < ApplicationController

  def index
    @world = World.last
    @cells = Cell.includes(:terrain).includes(:world).order(:row).order(:column)
    .each_slice(@world.max_columns).to_a
  end

end
