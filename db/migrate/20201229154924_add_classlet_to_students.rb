# frozen_string_literal: true

class AddClassletToStudents < ActiveRecord::Migration[6.0]
  def change
    add_column :students, :classlet, :string
  end
end
