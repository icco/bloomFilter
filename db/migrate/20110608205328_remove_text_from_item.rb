class RemoveTextFromItem < ActiveRecord::Migration
  def self.up
    remove_column :items, :text
  end

  def self.down
    add_column :items, :text, :text
  end
end
