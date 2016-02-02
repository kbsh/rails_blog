class AddColumnToTag < ActiveRecord::Migration
  def change
    add_column :tags, :display, :integer, limit: 1, default: 0
    add_column :tags, :count, :integer, default: 0

    add_index :tags, :display
  end
end
