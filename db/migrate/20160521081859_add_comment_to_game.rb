class AddCommentToGame < ActiveRecord::Migration
  def change
    add_column :games, :comment, :string, limit: 24
  end
end
