class ItemDistance < ActiveRecord::Base
   belongs_to :item1, :class_name => 'Item', :foreign_key => :item1_id
   belongs_to :item2, :class_name => 'Item', :foreign_key => :item2_id
end
