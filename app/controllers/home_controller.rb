class HomeController < ApplicationController
   def index
      if current_user.nil?
         @items = Item.order("created_at DESC").limit(25)
      else
         likes = current_user.likes
         recent = Item.order("created_at DESC")

         @items = []
         likes.each do |like|
            like.similar.each do |item|
               if !item.user_voted? current_user
                  @items.push item
               end
            end
         end

         #@items = @items.sort {|a,b| b.created_at <=> a.created_at }
         @items = @items.slice(0..25)

         if @items.count < 25
            @items = @items.concat(Item.order("created_at DESC").limit(25-@items.count()))
         end
      end
   end
end
