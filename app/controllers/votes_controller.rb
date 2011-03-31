class VotesController < ApplicationController
   before_filter :authenticate_user!

   # GET /votes
   def index
      @votes = Vote.all

      respond_to do |format|
         format.html # index.html.erb
         format.xml  { render :xml => @votes }
      end
   end

   def up
      @item = Item.find(params[:id])
      @item.vote('up', current_user)

      redirect_to @item
   end

   def flag
      @item = Item.find(params[:id])
      @item.vote('flag', current_user)

      redirect_to @item
   end
end
