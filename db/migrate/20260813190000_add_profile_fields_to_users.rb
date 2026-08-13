class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    # Keep profile fields nullable so existing accounts can be migrated safely.
    # Application validation requires a name only when a new account is created.
    add_column :users, :name, :string
    add_column :users, :phone, :string
    add_column :users, :address_line_1, :string
    add_column :users, :address_line_2, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :postal_code, :string
    add_column :users, :country_code, :string, limit: 2
  end
end
