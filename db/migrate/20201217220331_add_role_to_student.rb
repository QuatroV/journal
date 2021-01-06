# frozen_string_literal: true

class AddRoleToStudent < ActiveRecord::Migration[6.0]
  def change
    add_column :students, :role, :string
  end
end
