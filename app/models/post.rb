class Post < ApplicationRecord
    has_many :posttags
    has_many :tags, through: :posttags
    belongs_to :author

    def author_name
        author.name 
    end 
end
