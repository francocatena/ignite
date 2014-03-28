class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :rate
      t.string :ip
      t.text :comments
      t.references :lesson

      t.timestamps
    end

    add_index :feedbacks, :lesson_id
  end
end
