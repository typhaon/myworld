class Cell < ActiveRecord::Base
  belongs_to :terrain
  belongs_to :world
end
