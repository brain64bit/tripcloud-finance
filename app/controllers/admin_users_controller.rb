class AdminUsersController < ApplicationController
	load_and_authorize_resource
  add_breadcrumb "Admin User", :index_path

  helper_method :index_path

  def index
  	@admin_users = AdminUser.order("name asc")#AdminUser.order("name desc").page(params[:page]).per(10)
    @title = "Admin User"
  end

  def new
  	@admin_user = AdminUser.new
    add_breadcrumb "Add new", new_admin_user_path
  end

  def edit
  	@admin_user = AdminUser.find(params[:id])
    add_breadcrumb "Edit", admin_user_path(@admin_user), title: @admin_user.name
  end

  def show
  	@admin_user = AdminUser.find(params[:id])
    add_breadcrumb @admin_user.name, admin_user_path(@admin_user), title: @admin_user.name
  end

  def create
  	@admin_user = AdminUser.new(params[:admin_user])
  	if @admin_user.save
  		redirect_to @admin_user, notice: "Successfully create admin user"
  	else
  		render 'new'
  	end
  end

  def update
  	@admin_user = AdminUser.find(params[:id]) 
  	if @admin_user.update_attributes(params[:admin_user])
  		redirect_to @admin_user, notice: "Successfully update admin user"
  	else
  		flash[:error] = "Failed to update admin user"
  		render 'edit'
  	end
  end

  def destroy
  	@admin_user = AdminUser.find(params[:id])
  	if @admin_user.destroy
  		redirect_to :back, notice: "Successfully delete admin user"
  	else
  		flash[:error] = "Failed to delete admin user"
  		redirect_to :back
  	end
  end

  # private
  def index_path
    admin_users_path
  end
end