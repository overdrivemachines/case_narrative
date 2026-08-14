class CreateCaseIssuesAndEvents < ActiveRecord::Migration[8.1]
  def change
    create_case_issues
    create_case_events
  end

  private

  def create_case_issues
    create_table :case_issues, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :case, type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.references :asserted_by_participant,
                   type: :uuid,
                   null: true,
                   foreign_key: { to_table: :case_participants, on_delete: :nullify }
      t.string :issue_type, null: false, limit: 32
      t.integer :position, null: false, default: 1
      t.string :title, null: false, limit: 180
      t.text :description
      t.string :statute_code, limit: 120
      t.string :status, null: false, default: "open", limit: 32
      t.string :disposition, limit: 100
      t.date :disposed_on
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :case_issues, [ :case_id, :issue_type, :status ]
    add_index :case_issues, [ :case_id, :position ]
  end

  def create_case_events
    create_table :case_events, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :case, type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.references :created_by,
                   type: :uuid,
                   null: true,
                   foreign_key: { to_table: :users, on_delete: :nullify }

      t.string :event_type, null: false, limit: 40
      t.string :title, null: false, limit: 180
      t.text :description
      t.datetime :starts_at, null: false
      t.datetime :ends_at
      t.boolean :all_day, null: false, default: false
      t.string :location, limit: 180
      t.string :status, null: false, default: "scheduled", limit: 32
      t.string :source, limit: 180
      t.boolean :confidential, null: false, default: false
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :case_events, [ :case_id, :starts_at ]
    add_index :case_events, [ :case_id, :event_type ]
    add_index :case_events, [ :status, :starts_at ]
  end
end
