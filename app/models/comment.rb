class Comment < ActiveRecord::Base
   has_ancestry
   belongs_to :item
end
