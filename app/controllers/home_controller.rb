class HomeController < ApplicationController
   def index
      @items = Item.roots.limit(25)
   end
end
