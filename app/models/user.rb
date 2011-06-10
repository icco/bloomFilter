class User < ActiveRecord::Base
   devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

   # Setup accessible (or protected) attributes for your model
   attr_accessible :email, :username, :about, :password, :password_confirmation, :remember_me
   has_many :items
   has_many :votes

   has_many :likes, :class_name => "Item", :through => :votes, :source => :item, :conditions => "direction = 'up'", :order => "created_at DESC"

   validates_uniqueness_of :email, :username

   # TODO: Cache based on last upvote time
   def frontpage_items
      likes = self.likes
      recent = Item.order("created_at DESC")

      items = []
      likes.each do |like|
         like.similar.each do |item|
            if !item.user_voted? self
               items.push item
            end
         end
      end

      items = items.sort {|a,b| b.created_at <=> a.created_at }
      items = items.slice(0..25)

      if items.count < 25
         items = items.concat(Item.order("created_at DESC").limit(25-items.count()))
      end

      items.each do |item|
         item.cluster = Cluster.closest(item)
         item.save
      end

      return items
   end

   def User.valid_email x
      return !User.exists?(:email => x)
   end

   def User.valid_username x
      return !User.exists?(:username => x)
   end
end
