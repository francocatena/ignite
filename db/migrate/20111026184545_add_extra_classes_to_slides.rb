class AddExtraClassesToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :extra_classes, :string
    add_column :slides, :style, :string
  end
end
