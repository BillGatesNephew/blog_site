class Post < ApplicationRecord
    # Validations
    validates :title, presence: true, 
        length: { 
            in: 10..100,
            too_long: "%{count} characters is the longest title allowed.",
            too_sort: "%{count} characters is the shortest title allowed."
        }
    validates :summary, presence: true, 
        length: { 
            in: 20..300,
            too_long: "%{count} characters is the longest summary allowed.",
            too_sort: "%{count} characters is the shortest summary allowed."
        }
    validates :content, presence: true
    
    # Relationships
    has_many :posttags
    has_many :tags, through: :posttags
    belongs_to :author
end