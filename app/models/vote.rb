class Vote < ActiveRecord::Base
   belongs_to :user
   belongs_to :item

   validate_on_create :one_vote

   def one_vote
      errors.add_to_base("This vote already exists") if Vote.where({:item_id => self.item, :user_id => self.user}).count > 0
   end
end
