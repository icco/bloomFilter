class RemoveItemIdFromCluster < ActiveRecord::Migration
  def self.up
    remove_column :clusters, :item_id
  end

  def self.down
    add_column :clusters, :item_id, :integer
  end
end
