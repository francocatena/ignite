class AddCourseIdToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :course_id, :integer
    
    add_index :lessons, :course_id
  end
end