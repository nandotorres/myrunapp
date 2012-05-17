class AddFirstLoginToUser < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.datetime :last_login
      t.integer :login_count, :null => false, :default => 0
    end
  end
end
