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

   # this function returns the distance from another item.
   #
   # Original idea:
   # * If we both voted for it, 0
   # * If you submited it, and I voted for it, 1
   # * If I voted, but you did not, -1
   #
   # Currently implemented as a count of number of voters we share
   #
   # TODO: Cache!
   def distance item
      return (self.voters.keys & item.voters.keys).count
   end

   def voters
      users = {}
      self.votes.where(:direction => "up").each {|vote|
         users[vote.user.id] = vote.user if users[vote.user.id].nil?
      }

      return users
   end
end
