class RemoveLockVersionFromLessons < ActiveRecord::Migration[4.2]
  def change
    remove_column :lessons, :lock_version
  end
end
