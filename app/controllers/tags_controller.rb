class TagsController < ApplicationController
    before_action :authenticate_author!, only: [:new]

    def new 
        @errors = Array.new
        if tag_params["name"].length == 0 
            @errors << 'The tag name can\'t be empty.'
        end 
        if tag_params["desc"].length == 0
            @errors << 'The tag description can\'t be empty.'
        end 
        if Tag.tags_with_name?(tag_params["name"])
            @errors << 'A tag with that name already exists.'
        end 
        if @errors.count == 0 
            @tag = Tag.new(tag_params)
            @tag.save
        end 

        respond_to do |format|
            format.js
            format.html
        end
    end 

    private

        def tag_params
            params.require(:tag).permit(:name, :desc)
        end 
end 