class HomeController < ApplicationController
   def index
      @items = Item.roots
   end
end
