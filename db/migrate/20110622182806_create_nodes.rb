class CreateNodes < ActiveRecord::Migration
  def self.up
    create_table :nodes do |t|
      t.string :type # STI discriminator
      t.text :content
      t.integer :rank
      t.references :slide
      t.integer :lock_version, :default => 0

      t.timestamps
    end
    
    add_index :nodes, :slide_id
  end

  def self.down
    remove_index :nodes, :column => :slide_id
    
    drop_table :nodes
  end
end