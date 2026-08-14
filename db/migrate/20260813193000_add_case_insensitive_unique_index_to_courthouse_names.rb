class AddCaseInsensitiveUniqueIndexToCourthouseNames < ActiveRecord::Migration[8.1]
  def change
    add_index :courthouses,
              "LOWER(name)",
              unique: true,
              name: "index_courthouses_on_lower_name"
  end
end
