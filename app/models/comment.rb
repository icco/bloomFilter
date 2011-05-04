class Comment < ActiveRecord::Base
   has_ancestry
   belongs_to :item
   belongs_to :user
end
