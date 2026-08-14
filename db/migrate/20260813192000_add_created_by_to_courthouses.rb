class AddCreatedByToCourthouses < ActiveRecord::Migration[8.1]
  def change
    add_reference :courthouses,
                  :created_by,
                  type: :uuid,
                  null: true,
                  foreign_key: { to_table: :users }
  end
end
