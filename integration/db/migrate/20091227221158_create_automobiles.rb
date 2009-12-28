class CreateAutomobiles < ActiveRecord::Migration
  def self.up
    create_table :automobiles do |t|
      t.float :urbanity
      t.float :weekly_distance_estimate
      t.float :weekly_cost_estimate

      t.timestamps
    end
  end

  def self.down
    drop_table :automobiles
  end
end
