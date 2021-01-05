class CreateLessons < ActiveRecord::Migration[6.0]
  def change
    create_table :lessons do |t|
      t.date :day, null: false
      t.integer :pos, null: false
      t.string :subject, null: false
      t.string :homework
      t.integer :classnum, null: false
      t.string :classlet, null: false
      t.integer :teacher_id, null: false
      
      t.timestamps
    end
  end
end
