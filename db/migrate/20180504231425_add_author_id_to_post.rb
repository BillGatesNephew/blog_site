class AddAuthorIdToPost < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :author, foreign_key: true
  end
end
