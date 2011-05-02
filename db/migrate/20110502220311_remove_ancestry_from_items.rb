class RemoveAncestryFromItems < ActiveRecord::Migration
  def self.up
    remove_index :items, :ancestry
    remove_column :items, :ancestry
  end

  def self.down
    add_column :items, :ancestry, :string
    add_index :items, :ancestry 
  end
end
