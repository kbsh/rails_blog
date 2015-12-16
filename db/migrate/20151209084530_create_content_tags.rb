class CreateContentTags < ActiveRecord::Migration
  def change
    create_table :content_tags do |t|
      t.integer    :content_id, null: false
      t.integer    :tag_id,     null: false
      t.timestamps              null: false
    end

    add_index :content_tags, :content_id
    add_index :content_tags, :tag_id
  end
end
