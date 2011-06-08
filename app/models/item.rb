class Item < ActiveRecord::Base
   # So we can user url_for
   include Rails.application.routes.url_helpers

   # defines relationships.
   belongs_to :user
   has_many :votes
   has_many :comments

   # Creates the voters function for us.
   has_many :voters, :class_name => "User", :through => :votes, :source => :user, :conditions => "direction = 'up'"

   # For k-means
   belongs_to :cluster

   validates_uniqueness_of :url
   after_validation(Item.after_validation, :on => :create)

   # Doesn't work as wanted. But an idea.
   def Item.after_validation i
      if i.errors.on(:url).present?
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

   # This function returns the euclidean distance in an N-dimensional space
   # from another item.
   # TODO: Cache!
   def distance item
      if !item.is_a? Item
         raise "Cannot calculate distance to object that is not an item."
      end

      disance = 0 if self == item
      id = ItemDistance.where({
         :item1_id => self.id,
         :item2_id => item.id,
      }).first

      if id.nil?
         id = ItemDistance.new({
            :item1_id => self.id,
            :item2_id => item.id,
         })
      else
         # An hour DB cache
         distance = id.distance if Time.now - id.updated_at < 60*60
      end

      if distance.nil?
         # this in reality is supposed to be sum(each dimmension (b-a)^2) but
         # because the values are all one or zero, we can do this
         diff = (self.voters.to_set - item.voters.to_set).count
         distance = Math.sqrt(diff)

         id.distance = distance
         id.save
      end

      return distance
   end

   # TODO: Cache!
   # Uses clustering to find similar posts.
   def similar
      if self.cluster.nil? or (Time.now - self.cluster.updated_at) > (60*60)
         Cluster.rebuild
         self.cluster = Cluster.closest(self)
      end

      return Item.where(:cluster_id => self.cluster.id).order("created_at DESC").limit(25)
   end

   # Takes in a column vector matching userids to whether or not they voted. We
   # try and find an item similar to that.
   def Item.from_vector vector
      item_hash = {}
      item_hash.default = 0

      vector.each_index do |userid|
         if vector[userid] > 0
            User.find(userid).likes.select('item_id').each do |like|
               item_hash[like.id] += 1
            end
         end
      end

      most_common_item = 0

      item_hash.each_pair do |k,v|
         if item_hash[most_common_item] < v
            most_common_item = k
         end
      end

      item = nil
      item = Item.find(most_common_item) if most_common_item > 0

      return item
   end
end
