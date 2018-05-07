class Posttag < ApplicationRecord
    belongs_to :post
    belongs_to :tag

    def self.add_tags_to_post(post, tags)
        # Remove all tags currently associated with the Post
        Posttag.all.where(post_id: post.id).destroy_all
        # Create new Posttags for Post
        tags.each do |tag|
            tag_id= Tag.all.where(name: tag).first.id
            Posttag.create(tag_id: tag_id, post_id: post.id)
        end 
    end 

    def self.remove_posttags_for_tag(tag)
        Posttag.all.where(tag_id: tag.id).destroy_all
    end

    def self.tags_for_post(post)
        posttags = Posttag.all.where(post_id: post.id)
        tags = Array.new 
        posttags.each do |posttag|
            tags << Tag.all.where(id: posttag.tag_id).first
        end 
        tags = tags.uniq
        return tags
    end 
end
