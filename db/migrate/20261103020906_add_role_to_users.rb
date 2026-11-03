class AddRoleToUsers < ActiveRecord::Migration[8.1]
  # Adds a required role, defaulting existing and new users to unapproved.
  # Called by Rails when applying or reversing this migration.
  def change
    add_column :users, :role, :integer, default: 0, null: false
  end
end
