class HomeController < ApplicationController
   def index
      @items = Item.order(:created_at).limit(25)
   end
end
