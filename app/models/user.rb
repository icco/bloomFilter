class User < ActiveRecord::Base
   devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

   # Setup accessible (or protected) attributes for your model
   attr_accessible :email, :username, :about, :password, :password_confirmation, :remember_me
   has_many :items
   has_many :votes
end
