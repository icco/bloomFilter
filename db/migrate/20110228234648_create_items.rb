class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :url
      t.string :title
      t.text :text
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
