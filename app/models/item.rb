class Item < ActiveRecord::Base
   belongs_to :user
   has_many :items
   has_many :votes
end
