class Posttag < ApplicationRecord
    belongs_to :post
    belongs_to :tag

    # Sets the tags for a given post, 
    def self.add_tags_to_post(post, tags)
        # Remove all tags currently associated with the Post
        Posttag.all.where(post_id: post.id).destroy_all
        # Create new Posttags for each Tag to associate with the Post
        tags.each do |tag|
            tag_id= Tag.all.where(name: tag).first.id
            Posttag.create(tag_id: tag_id, post_id: post.id)
        end 
    end 

    # Removes all the Posttag records associated with a given Tag
    def self.remove_posttags_for_tag(tag)
        Posttag.all.where(tag_id: tag.id).destroy_all
    end
end