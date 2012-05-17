class ChangeUsersAddAvatarActiveLevel < ActiveRecord::Migration
  def up
    change_table(:users) do |t|
      t.string :avatar, :null => true
      t.float :total_distance, :default => 0
      t.boolean :active, :null => false, :default => true
    end
    add_index :users, :active
  end

  def down
  end
end
