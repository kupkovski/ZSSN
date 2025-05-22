class CreateInfectedUserReports < ActiveRecord::Migration[8.0]
  def change
    create_table :infected_user_reports do |t|
      t.references :suspect, null: false, foreign_key: { to_table: :users }
      t.references :reporter, null: false, foreign_key: { to_table: :users } 

      t.timestamps
    end
  end
end
