class Cluster < ActiveRecord::Base
   has_many :items
   belongs_to :point, :class_name => 'Item', :foreign_key => 'item_id'
end
