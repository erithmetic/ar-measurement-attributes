class AddDisplacementToBoat < ActiveRecord::Migration
  def self.up
    add_column(:boats, :displacement, :float)
  end

  def self.down
  end
end
