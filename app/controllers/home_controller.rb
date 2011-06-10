class HomeController < ApplicationController
   def index
      if current_user.nil?
         @items = Item.order("created_at DESC").limit(25)
      else
         @items = current_user.frontpage_items
      end
   end
end
