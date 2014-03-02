class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.integer :user_id
      t.integer :size
      t.integer :type
      t.string :title
      t.string :place
      t.text :desc

      t.timestamps
    end
  end
end
