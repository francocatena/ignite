class AddCourseIdToLessons < ActiveRecord::Migration[4.2]
  def change
    add_column :lessons, :course_id, :integer

    add_index :lessons, :course_id
  end
end
