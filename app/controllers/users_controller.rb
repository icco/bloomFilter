class UsersController < ApplicationController
   load_and_authorize_resource

   def index
      @users = User.all
   end

   def show
      @user = User.find(params[:id])

      respond_to do |format|
         format.html # show.html.erb
         format.json { render :json => @user }
      end
   end

   def edit
      redirect_to edit_user_registration_path
   end

   def update
      redirect_to edit_user_registration_path
   end

   def new
      @user = User.new
   end

   def create
      @user = User.new(params[:user])

      if @user.save
         flash[:notice] = "Successfully created User." 
         redirect_to root_path
      else
         render :action => 'new'
      end
   end

   def destroy
      @user = User.find(params[:id])
      if @user.destroy
         flash[:notice] = "Successfully deleted User."
         redirect_to root_path
      end
   end
end
