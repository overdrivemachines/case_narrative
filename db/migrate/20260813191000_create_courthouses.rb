class CreateCourthouses < ActiveRecord::Migration[8.1]
  def change
    create_table :courthouses, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.string :name, null: false, limit: 80
      t.string :address, null: false, limit: 50
      t.string :city, null: false, limit: 30
      t.string :state, null: false, limit: 2
      t.string :jurisdiction, null: false, limit: 80
      t.string :homepage, limit: 200
      t.references :created_by, type: :uuid, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
