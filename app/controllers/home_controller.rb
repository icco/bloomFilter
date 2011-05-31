class HomeController < ApplicationController
   def index

      # take all posts user has liked.
      if current_user.nil?
         @items = Item.order("created_at DESC").limit(25)
      else
         likes = current_user.likes
         recent = Item.order("created_at DESC").limit(100)
         
         likes.each do |item1|
            recent.each do |item2|
               id = ItemDistance.new
               id.item1_id = item1.id
               id.item2_id = item2.id
               id.distance = item1.distance item2
               id.save
            end
         end

         @items = []
         likes.each do |like|
            ids = ItemDistance.where(:item1_id => like.id).order("distance DESC").limit(10)
            ids.each {|id|
               if !id.item2.user_voted? current_user
                  @items.push id.item2
               end
            }
         end

         @items.sort {|a,b| b.created_at <=> a.created_at }
      end
   end
end
