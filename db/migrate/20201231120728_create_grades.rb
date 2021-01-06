# frozen_string_literal: true

class CreateGrades < ActiveRecord::Migration[6.0]
  def change
    create_table :grades do |t|
      t.integer :value
      t.references :student, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true

      t.timestamps
    end
  end
end
