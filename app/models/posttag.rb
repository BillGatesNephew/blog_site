class Posttag < ApplicationRecord
    belongs_to :post
    belongs_to :tag

    def self.add_tags_to_post(post, tags)
        tags.each do |tag|
            tagId = Tag.all.where(name: tag).first.id
            postId = post.id
            Posttag.create(tag_id: tagId, post_id: postId)
        end 
    end 
end
