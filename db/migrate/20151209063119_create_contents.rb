class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string     :filename, null: false
      t.string     :title,    null: false
      t.integer    :count,    null: false, default: 0

      t.timestamps            null: false
    end
  end
end
