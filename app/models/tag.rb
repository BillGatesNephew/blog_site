class Tag < ApplicationRecord
    has_many :posttags
    has_many :posts, through: :posttags

    def self.tags_with_name?(name)
        return Tag.all.where('lower(name) = ?', name.downcase).count > 0
    end 
end
