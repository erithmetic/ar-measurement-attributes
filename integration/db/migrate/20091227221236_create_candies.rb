class CreateCandies < ActiveRecord::Migration
  def self.up
    create_table :candies do |t|
      t.float :price

      t.timestamps
    end
  end

  def self.down
    drop_table :candies
  end
end
