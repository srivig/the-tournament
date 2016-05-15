class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :user_id, null: false
      t.integer :count, null: false
      t.integer :size, null: false
      t.date :expires_at, null: false

      t.timestamps
    end
    add_index :plans, :user_id
    add_index :plans, :expires_at
  end
end
