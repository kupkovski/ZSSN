class RemoveInfectedFieldFromUsers < ActiveRecord::Migration[8.0]
  def up
    remove_column :users, :infected
  end

  def down
    add_column :users, :infected, :boolean
  end
end
