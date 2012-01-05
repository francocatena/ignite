class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.text :notes
      t.integer :lock_version, default: 0

      t.timestamps
    end
    
    add_index :courses, :name, unique: true
  end
end