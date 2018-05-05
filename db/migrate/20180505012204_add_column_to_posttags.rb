class AddColumnToPosttags < ActiveRecord::Migration[5.1]
  def change
    add_column :posttags, :tag_id, :integer
    add_column :posttags, :post_id, :integer
  end
end
