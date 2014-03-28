class AddLessonIdToSlides < ActiveRecord::Migration
  def self.up
    add_column :slides, :lesson_id, :integer

    add_index :slides, :lesson_id
  end

  def self.down
    remove_index :slides, :column => :lesson_id

    remove_column :slides, :lesson_id
  end
end
