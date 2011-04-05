class Item < ActiveRecord::Base
   # So we can user url_for
   include Rails.application.routes.url_helpers

   # defines relationships.
   belongs_to :user
   has_many :votes
   has_ancestry

   def comments
      return self.descendants
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

   def user_voted? user
      if user
         return Vote.where({:item_id => self, :user_id => user}).count > 0
      else
         return false
      end
   end
end
