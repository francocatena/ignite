class RemoveLockVersionFromSlides < ActiveRecord::Migration[4.2]
  def change
    remove_column :slides, :lock_version
  end
end
