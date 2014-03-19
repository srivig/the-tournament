class RenameDescColumnToDetail < ActiveRecord::Migration
  def change
    change_table :tournaments do |t|
      t.rename :desc, :detail
    end
  end
end
