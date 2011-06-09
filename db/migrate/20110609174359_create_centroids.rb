class CreateCentroids < ActiveRecord::Migration
  def self.up
    create_table :centroids do |t|
      t.integer :cluster_id
      t.integer :user_id
      t.float :average

      t.timestamps
    end
  end

  def self.down
    drop_table :centroids
  end
end
