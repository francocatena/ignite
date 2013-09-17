class RemoveLockVersionFromSlides < ActiveRecord::Migration
  def change
    remove_column :slides, :lock_version
  end
end
