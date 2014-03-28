class CreateNodes < ActiveRecord::Migration
  def self.up
    create_table :nodes do |t|
      t.string :type # STI discriminator
      t.text :content
      t.text :options
      t.integer :rank
      t.references :slide
      t.integer :lock_version, :default => 0

      t.timestamps
    end

    add_index :nodes, :slide_id
    add_index :nodes, :type
  end

  def self.down
    remove_index :nodes, :column => :slide_id
    remove_index :nodes, :column => :type

    drop_table :nodes
  end
end
