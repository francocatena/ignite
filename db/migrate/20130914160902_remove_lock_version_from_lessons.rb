class RemoveLockVersionFromLessons < ActiveRecord::Migration
  def change
    remove_column :lessons, :lock_version
  end
end
