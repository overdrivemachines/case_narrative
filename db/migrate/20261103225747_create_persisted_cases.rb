class CreatePersistedCases < ActiveRecord::Migration[8.1]
  # Creates the case records used by the case workspace.
  # Called by Rails when applying this migration.
  def change
    create_table :cases, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.string :title, null: false, limit: 180
      t.string :case_number, null: false, limit: 100
      t.string :case_type, null: false, limit: 32
      t.string :county, null: false, limit: 120
      t.date :filed_on, null: false
      t.string :status, null: false, limit: 32
      t.text :description, null: false

      t.timestamps
    end

    add_index :cases, "lower(case_number)", name: "index_cases_on_lower_case_number", unique: true
  end
end
