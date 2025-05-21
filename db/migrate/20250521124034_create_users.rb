class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.datetime :birthdate
      t.string :gender
      t.float :latitude
      t.float :longitude
      t.boolean :infected

      t.timestamps
    end
  end
end
