class ApplicationController < ActionController::Base
  before_action :set_current_tags
  before_action :set_can_remove_tags
  protect_from_forgery with: :exception

  private 
    # Sets the Tags available for authors that are logged in to edit/remove
    def set_current_tags 
      @tags = Tag.all.sort_by{ |tag| tag.name.downcase }
    end 

    # Set the ability to remove post Tags only on pages that don't involve creating/changing a post
    def set_can_remove_tags
      @can_remove_tags = params[:controller] != 'posts' || (params[:action] != 'new' && params[:action] != 'edit')
    end 
end