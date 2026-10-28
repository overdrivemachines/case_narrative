class CreateCases < ActiveRecord::Migration[8.1]
  def change
    create_table :cases, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :courthouse,
                   type: :uuid,
                   null: true,
                   foreign_key: { on_delete: :nullify }
      t.references :created_by,
                   type: :uuid,
                   null: false,
                   foreign_key: { to_table: :users, on_delete: :restrict }

      t.string :title, null: false, limit: 180
      t.string :case_number, null: false, limit: 100
      t.string :case_type, null: false, limit: 32
      t.string :status, null: false, default: "active", limit: 32
      t.date :start_date, null: false
      t.date :filed_on
      t.date :closed_on
      t.string :court_division, limit: 100
      t.string :judge_name, limit: 120
      t.text :description
      t.text :summary
      t.jsonb :charges, null: false, default: []
      t.datetime :next_event_at
      t.boolean :confidential, null: false, default: false
      t.jsonb :metadata, null: false, default: {}
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :cases, :case_number
    add_index :cases, [ :case_type, :status ]
    add_index :cases, :start_date
    add_index :cases, :next_event_at
    add_index :cases, :charges, using: :gin
    add_index :cases, "lower(title)", name: "index_cases_on_lower_title"
    add_index :cases, "lower(case_number)", name: "index_cases_on_lower_case_number"
  end
end
