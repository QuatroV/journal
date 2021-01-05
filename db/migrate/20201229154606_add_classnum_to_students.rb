class AddClassnumToStudents < ActiveRecord::Migration[6.0]
  def change
    add_column :students, :classnum, :integer
  end
end
