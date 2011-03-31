class Item < ActiveRecord::Base
   belongs_to :user
   has_many :items
   has_many :votes

   def vote direction, user
      vote = Vote.new
      vote.item = self
      vote.user = user
      vote.direction = direction
      vote.save

      return vote
   end
end
