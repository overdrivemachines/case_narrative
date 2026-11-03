# frozen_string_literal: true

class RemoveCountryCodeFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :country_code, :string, limit: 2 if column_exists?(:users, :country_code)
  end
end
