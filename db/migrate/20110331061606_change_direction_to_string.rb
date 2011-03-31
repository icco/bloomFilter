class ChangeDirectionToString < ActiveRecord::Migration
   def self.up
      change_table :votes do |t|
         t.change :direction, :string
      end
   end

   def self.down
   end
end
