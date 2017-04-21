class CreateSlides < ActiveRecord::Migration[4.2]
  def self.up
    create_table :slides do |t|
      t.string :title
      t.integer :number
      t.integer :lock_version, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :slides
  end
end
