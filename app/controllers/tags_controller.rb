class TagsController < ApplicationController
    before_action :authenticate_author!, only: [:new, :update, :delete]

    # POST /tag/new
    def new 
        @errors = validate_params(tag_params)
        if @errors.count == 0 
            @tag = Tag.new(tag_params)
            @tag.save
        end 

        respond_to do |format|
            format.js
            format.html
        end
    end 

    # PUT /tags/:id
    def update
        @errors = validate_params(tag_params)
        @tag_id = 'tag' + params["id"].to_s
        if @errors.count == 0
            tag = Tag.where(id: params["id"])
            tag.update(tag_params)
            redirect_back fallback_location: :root
        end 

        respond_to do |format|
            format.js
            format.html
        end 
    end 

    # DELETE /tags/:id
    def delete
        tag = Tag.where(id: params["id"]).first
        Posttag.remove_posttags_for_tag(tag)
        tag.destroy
        redirect_back fallback_location: :root
    end 

    private

        # Validates the parameters passed by a form to update a Tag record
        def validate_params(params)
            errors = []
            # Check that the Tag's param fields are not empty
            if params["name"].strip.length == 0 
                errors << 'The tag name can\'t be empty.'
            end 
            if params["desc"].strip.length == 0
                errors << 'The tag description can\'t be empty.'
            end 
            # Check that a Tag does not already exist with the same name
            if Tag.tags_with_name?(tag_params["name"])
                errors << 'A tag with that name already exists.'
            end 
            return errors
        end 

        # Whitelists the params passed for creating/updating a Tag record
        def tag_params
            params.require(:tag).permit(:name, :desc)
        end 
end 