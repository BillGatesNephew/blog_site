class Tag < ApplicationRecord
    has_many :posttags
    has_many :posts, through: :posttags
end
