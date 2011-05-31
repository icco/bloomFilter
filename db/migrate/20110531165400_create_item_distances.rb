class CreateItemDistances < ActiveRecord::Migration
  def self.up
    create_table :item_distances do |t|
      t.integer :item1_id
      t.integer :item2_id
      t.integer :distance

      t.timestamps
    end
  end

  def self.down
    drop_table :item_distances
  end
end
