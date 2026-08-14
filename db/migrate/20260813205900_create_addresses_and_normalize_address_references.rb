class CreateAddressesAndNormalizeAddressReferences < ActiveRecord::Migration[8.1]
  def up
    create_table :addresses, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.string :line_1, limit: 120
      t.string :line_2, limit: 120
      t.string :city, limit: 80
      t.string :state, limit: 80
      t.string :postal_code, limit: 20
      t.string :country_code, null: false, default: "US", limit: 2

      t.timestamps
    end

    add_index :addresses, [ :postal_code, :country_code ]
    add_reference :users, :address, type: :uuid, null: true, foreign_key: { on_delete: :restrict }
    add_reference :courthouses, :address, type: :uuid, null: true, foreign_key: { on_delete: :restrict }

    backfill_addresses

    change_column_null :courthouses, :address_id, false
    remove_legacy_address_columns
  end

  def down
    restore_legacy_address_columns
    restore_legacy_address_values

    remove_reference :courthouses, :address, foreign_key: true
    remove_reference :users, :address, foreign_key: true
    drop_table :addresses
  end

  private

  def backfill_addresses
    execute <<~SQL.squish
      DO $$
      DECLARE
        owner RECORD;
        new_address_id uuid;
      BEGIN
        FOR owner IN
          SELECT id, address, city, state
          FROM courthouses
        LOOP
          new_address_id := uuidv7();
          INSERT INTO addresses (id, line_1, city, state, country_code, created_at, updated_at)
          VALUES (new_address_id, owner.address, owner.city, owner.state, 'US', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
          UPDATE courthouses SET address_id = new_address_id WHERE id = owner.id;
        END LOOP;

        FOR owner IN
          SELECT id, address_line_1, address_line_2, city, state, postal_code, country_code
          FROM users
          WHERE NULLIF(BTRIM(COALESCE(address_line_1, '')), '') IS NOT NULL
             OR NULLIF(BTRIM(COALESCE(address_line_2, '')), '') IS NOT NULL
             OR NULLIF(BTRIM(COALESCE(city, '')), '') IS NOT NULL
             OR NULLIF(BTRIM(COALESCE(state, '')), '') IS NOT NULL
             OR NULLIF(BTRIM(COALESCE(postal_code, '')), '') IS NOT NULL
             OR NULLIF(BTRIM(COALESCE(country_code, '')), '') IS NOT NULL
        LOOP
          new_address_id := uuidv7();
          INSERT INTO addresses (id, line_1, line_2, city, state, postal_code, country_code, created_at, updated_at)
          VALUES (
            new_address_id,
            owner.address_line_1,
            owner.address_line_2,
            owner.city,
            owner.state,
            owner.postal_code,
            COALESCE(NULLIF(BTRIM(owner.country_code), ''), 'US'),
            CURRENT_TIMESTAMP,
            CURRENT_TIMESTAMP
          );
          UPDATE users SET address_id = new_address_id WHERE id = owner.id;
        END LOOP;
      END $$;
    SQL
  end

  def remove_legacy_address_columns
    remove_columns :users,
                   :address_line_1,
                   :address_line_2,
                   :city,
                   :state,
                   :postal_code,
                   :country_code
    remove_columns :courthouses, :address, :city, :state
  end

  def restore_legacy_address_columns
    add_column :users, :address_line_1, :string
    add_column :users, :address_line_2, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :postal_code, :string
    add_column :users, :country_code, :string, limit: 2

    add_column :courthouses, :address, :string, limit: 50
    add_column :courthouses, :city, :string, limit: 30
    add_column :courthouses, :state, :string, limit: 2
  end

  def restore_legacy_address_values
    execute <<~SQL.squish
      UPDATE users
      SET address_line_1 = addresses.line_1,
          address_line_2 = addresses.line_2,
          city = addresses.city,
          state = addresses.state,
          postal_code = addresses.postal_code,
          country_code = addresses.country_code
      FROM addresses
      WHERE users.address_id = addresses.id;

      UPDATE courthouses
      SET address = addresses.line_1,
          city = addresses.city,
          state = addresses.state
      FROM addresses
      WHERE courthouses.address_id = addresses.id;
    SQL

    change_column_null :courthouses, :address, false
    change_column_null :courthouses, :city, false
    change_column_null :courthouses, :state, false
  end
end
