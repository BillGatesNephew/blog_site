class Post < ApplicationRecord
    has_many :posttags
    has_many :tags, through: :posttags
    belongs_to :author
end