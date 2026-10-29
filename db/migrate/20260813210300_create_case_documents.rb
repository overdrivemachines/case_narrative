class CreateCaseDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :case_documents, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :case, type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.references :created_by,
                   type: :uuid,
                   null: true,
                   foreign_key: { to_table: :users, on_delete: :nullify }
      t.references :filed_by_participant,
                   type: :uuid,
                   null: true,
                   foreign_key: { to_table: :case_participants, on_delete: :nullify }

      t.string :document_type, null: false, limit: 40
      t.string :title, null: false, limit: 180
      t.string :document_number, limit: 100
      t.text :description
      t.string :status, null: false, default: "draft", limit: 32
      t.date :authored_on
      t.datetime :filed_at
      t.datetime :served_at
      t.datetime :received_at
      t.boolean :confidential, null: false, default: false
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :case_documents, [ :case_id, :document_type ]
    add_index :case_documents, [ :case_id, :filed_at ]
    add_index :case_documents, [ :case_id, :document_number ]
  end
end
