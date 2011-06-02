class HomeController < ApplicationController
   def index
      if current_user.nil?
         @items = Item.order("created_at DESC").limit(25)
      else
         likes = current_user.likes
         recent = Item.order("created_at DESC")

         @items = []
         likes.each do |like|
            ids = ItemDistance.where(:item1_id => like.id).order("distance DESC").limit(10)
            ids.each do |id|
               if !id.item2.user_voted? current_user
                  @items.push id.item2
               end
            end
         end

         @items = @items.sort {|a,b| b.created_at <=> a.created_at }
         @items = @items.slice(0..25)

         if @items.count < 25
            @items = @items.concat(Item.order("created_at DESC").limit(25-@items.count()))
         end
      end
   end
end
