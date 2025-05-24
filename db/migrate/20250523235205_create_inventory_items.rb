class CreateInventoryItems < ActiveRecord::Migration[8.0]
  def change
    create_table :inventory_items do |t|
      t.references :inventory, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
