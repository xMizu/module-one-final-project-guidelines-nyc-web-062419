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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190711133747) do

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.string   "url"
    t.string   "source_name"
    t.text     "content"
    t.datetime "publishedAt"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "article_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "comment_timestamp"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "article_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
  end

end
