class Post < ApplicationRecord
    belongs_to :author

    def author_name
        author.name 
    end 
end
