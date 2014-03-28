class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :name, null: false
      t.string :caption, null: false
      t.string :image_file_name, null: false
      t.string :image_content_type, null: false
      t.integer :image_file_size, null: false
      t.datetime :image_updated_at, null: false
      t.integer :lock_version, default: 0

      t.timestamps
    end

    add_index :images, :name, unique: true
  end

  def self.down
    remove_index :images, column: [:name]

    drop_table :images
  end
end
