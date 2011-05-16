class Item < ActiveRecord::Base
   # So we can user url_for
   include Rails.application.routes.url_helpers

   # defines relationships.
   belongs_to :user
   has_many :votes
   has_many :comments

   validates_uniqueness_of :url
   after_validation_on_create :after_validation

   # Doesn't work as wanted. But an idea.
   def after_validation
      if errors.on(:url).present?
        item = Item.where(:url => self.url).first
        item.vote 'up', self.user
      end
   end

   def base_uri
      item_path(self)
   end

   def url
      if super != ""
         u = super
      else
         u = self.base_uri
      end

      return u
   end

   def vote direction, user
      vote = Vote.new
      vote.item = self
      vote.user = user
      vote.direction = direction

      # returns false if validations fail.
      return vote.save
   end

   def user_flagged? user
      if user
         return Vote.where({:item_id => self, :user_id => user, :direction => 'flag'}).count > 0
      else
         return false
      end
   end

   def user_voted? user
      if user
         return Vote.where({:item_id => self, :user_id => user, :direction => 'up'}).count > 0
      else
         return false
      end
   end

   def up_votes
      item.votes.where(:direction => "up")
   end

   # this function returns the distance from another item.
   def distance item
      a_votes = self.up_votes.count
      b_votes = item.up_votes.count

      return (a_votes - b_votes).abs
   end
end
