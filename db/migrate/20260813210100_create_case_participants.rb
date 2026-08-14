class CreateCaseParticipants < ActiveRecord::Migration[8.1]
  def change
    create_attorney_profiles
    create_case_participants
    create_case_participations
  end

  private

  def create_attorney_profiles
    create_table :attorney_profiles, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :user,
                   type: :uuid,
                   null: false,
                   index: { unique: true },
                   foreign_key: { on_delete: :cascade }
      t.references :address, type: :uuid, null: true, foreign_key: { on_delete: :restrict }

      t.string :bar_number, limit: 80
      t.string :licensing_state, limit: 2
      t.string :firm_name, limit: 180
      t.string :job_title, limit: 100
      t.string :email, limit: 254
      t.string :phone, limit: 40
      t.boolean :court_appointed, null: false, default: false
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :attorney_profiles,
              [ :licensing_state, :bar_number ],
              unique: true,
              where: "bar_number IS NOT NULL",
              name: "index_attorney_profiles_on_license"
  end

  def create_case_participants
    create_table :case_participants, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :user, type: :uuid, null: true, foreign_key: { on_delete: :nullify }
      t.references :attorney_profile, type: :uuid, null: true, foreign_key: { on_delete: :nullify }
      t.references :address, type: :uuid, null: true, foreign_key: { on_delete: :restrict }
      t.references :created_by,
                   type: :uuid,
                   null: true,
                   foreign_key: { to_table: :users, on_delete: :nullify }

      t.string :participant_type, null: false, limit: 32
      t.string :display_name, null: false, limit: 180
      t.string :first_name, limit: 80
      t.string :middle_name, limit: 80
      t.string :last_name, limit: 80
      t.string :name_suffix, limit: 20
      t.string :organization_name, limit: 180
      t.string :email, limit: 254
      t.string :phone, limit: 40
      t.date :date_of_birth
      t.date :date_of_death
      t.boolean :confidential, null: false, default: false
      t.jsonb :identifiers, null: false, default: {}
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :case_participants, :participant_type
    add_index :case_participants, "lower(display_name)", name: "index_case_participants_on_lower_name"
  end

  def create_case_participations
    create_table :case_participations, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :case, type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.references :case_participant, type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.string :role, limit: 40

      t.timestamps
    end

    add_index :case_participations,
              [ :case_id, :case_participant_id ],
              unique: true,
              name: "index_case_participations_uniquely"
    add_index :case_participations, [ :case_id, :role ]
  end
end
