class CreateLessons < ActiveRecord::Migration
  def self.up
    create_table :lessons do |t|
      t.string :name
      t.integer :sequence
      t.integer :lock_version, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :lessons
  end
end