# frozen_string_literal: true

class KeepOnlyUsers < ActiveRecord::Migration[8.1]
  def up
    # Preserve user addresses on the users row before removing the shared table.
    add_column :users, :address_line_1, :string unless column_exists?(:users, :address_line_1)
    add_column :users, :address_line_2, :string unless column_exists?(:users, :address_line_2)
    add_column :users, :city, :string unless column_exists?(:users, :city)
    add_column :users, :state, :string unless column_exists?(:users, :state)
    add_column :users, :postal_code, :string unless column_exists?(:users, :postal_code)
    if table_exists?(:addresses) && column_exists?(:users, :address_id)
      execute <<~SQL
        UPDATE users
        SET address_line_1 = addresses.line_1,
            address_line_2 = addresses.line_2,
            city = addresses.city,
            state = addresses.state,
            postal_code = addresses.postal_code
        FROM addresses
        WHERE users.address_id = addresses.id
      SQL
    end

    drop_table :case_documents, if_exists: true
    drop_table :case_events, if_exists: true
    drop_table :case_issues, if_exists: true
    drop_table :case_participations, if_exists: true
    drop_table :case_participants, if_exists: true
    drop_table :attorney_profiles, if_exists: true
    drop_table :cases, if_exists: true
    drop_table :courthouses, if_exists: true

    remove_reference :users, :address, foreign_key: true if column_exists?(:users, :address_id)
    drop_table :addresses, if_exists: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Removed application data cannot be restored"
  end
end
