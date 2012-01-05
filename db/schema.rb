# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120104164234) do

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.integer  "lock_version", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses", ["name"], :name => "index_courses_on_name", :unique => true

  create_table "images", :force => true do |t|
    t.string   "name",                              :null => false
    t.string   "caption",                           :null => false
    t.string   "image_file_name",                   :null => false
    t.string   "image_content_type",                :null => false
    t.integer  "image_file_size",                   :null => false
    t.datetime "image_updated_at",                  :null => false
    t.integer  "lock_version",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["name"], :name => "index_images_on_name", :unique => true

  create_table "lessons", :force => true do |t|
    t.string   "name"
    t.integer  "sequence"
    t.integer  "lock_version", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
  end

  add_index "lessons", ["course_id"], :name => "index_lessons_on_course_id"

  create_table "nodes", :force => true do |t|
    t.string   "type"
    t.text     "content"
    t.text     "options"
    t.integer  "rank"
    t.integer  "slide_id"
    t.integer  "lock_version", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nodes", ["slide_id"], :name => "index_nodes_on_slide_id"
  add_index "nodes", ["type"], :name => "index_nodes_on_type"

  create_table "slides", :force => true do |t|
    t.string   "title"
    t.integer  "number"
    t.integer  "lock_version",  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lesson_id"
    t.string   "extra_classes"
    t.string   "style"
  end

  add_index "slides", ["lesson_id"], :name => "index_slides_on_lesson_id"

end
