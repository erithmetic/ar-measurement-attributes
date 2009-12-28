class CreateBoats < ActiveRecord::Migration
  def self.up
    create_table :boats do |t|
      t.float :weekly_distance_estimate

      t.timestamps
    end
  end

  def self.down
    drop_table :boats
  end
end
