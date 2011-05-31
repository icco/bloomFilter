class User < ActiveRecord::Base
   devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

   # Setup accessible (or protected) attributes for your model
   attr_accessible :email, :username, :about, :password, :password_confirmation, :remember_me
   has_many :items
   has_many :votes

   has_many :likes, :class_name => "Item", :through => :votes, :source => :item, :conditions => "direction = 'up'", :order => "created_at DESC"

   validates_uniqueness_of :email, :username

   def User.valid_email x
      return !User.exists?(:email => x)
   end

   def User.valid_username x
      return !User.exists?(:username => x)
   end
end
