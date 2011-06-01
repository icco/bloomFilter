class HomeController < ApplicationController
   def index

      # take all posts user has liked.
      if current_user.nil?
         @items = Item.order("created_at DESC").limit(25)
      else
         likes = current_user.likes
         recent = Item.order("created_at DESC")

         likes.each do |item1|
            recent.each do |item2|
               if item1.distance(item2) != 0 and item1 != item2
                  id = ItemDistance.where({
                     :item1_id => item1.id,
                     :item2_id => item2.id,
                  }).first

                  if id.nil?
                     id = ItemDistance.new({
                        :item1_id => item1.id,
                        :item2_id => item2.id,
                     })
                  end

                  id.distance = item1.distance item2
                  id.save
               end
            end
         end

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
