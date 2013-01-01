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

ActiveRecord::Schema.define(:version => 20121223192627) do

  create_table "github_users", :force => true do |t|
    t.string   "login",         :null => false
    t.integer  "gh_id",         :null => false
    t.string   "url"
    t.string   "html_url"
    t.string   "name"
    t.string   "location"
    t.string   "email"
    t.datetime "gh_created_at"
    t.integer  "public_repos"
    t.integer  "private_repos"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "avatar_url"
  end

  create_table "terminations", :force => true do |t|
    t.string   "uuid"
    t.datetime "updated"
    t.string   "username"
    t.string   "fullname"
    t.string   "manager"
    t.string   "location"
    t.string   "term_date"
    t.string   "processed_by"
  end

  add_index "terminations", ["updated"], :name => "index_terminations_on_updated"
  add_index "terminations", ["uuid"], :name => "index_terminations_on_uuid", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",              :default => "", :null => false
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username",                           :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
