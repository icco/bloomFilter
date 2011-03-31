class RemoveItemIdFromItems < ActiveRecord::Migration
   def self.up
      remove_column :items, :item_id
   end

   def self.down
   end
end
