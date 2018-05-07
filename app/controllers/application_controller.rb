class ApplicationController < ActionController::Base
  before_action :set_current_tags
  protect_from_forgery with: :exception

  def set_current_tags 
    @tags = Tag.all
  end 
  
end
