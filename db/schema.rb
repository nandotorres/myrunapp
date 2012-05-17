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

ActiveRecord::Schema.define(:version => 20120510171723) do

  create_table "runs", :force => true do |t|
    t.integer  "user_id"
    t.datetime "start_time",                                         :null => false
    t.float    "distance",                       :default => 0.0,    :null => false
    t.integer  "duration",                       :default => 0,      :null => false
    t.datetime "sync_time",                                          :null => false
    t.float    "calories",                       :default => 0.0
    t.string   "name",            :limit => 60
    t.string   "description",     :limit => 150
    t.string   "how_felt",        :limit => 30
    t.string   "weather",         :limit => 30
    t.string   "terrain",         :limit => 30
    t.string   "intensity",       :limit => 30
    t.string   "equipmentType",   :limit => 20,  :default => "iPod"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "nikeplus_run_id"
  end

  add_index "runs", ["start_time"], :name => "index_runs_on_start_time"
  add_index "runs", ["user_id"], :name => "index_runs_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "provider",         :limit => 50,                         :null => false
    t.string   "uid",              :limit => 20,                         :null => false
    t.string   "name",             :limit => 20,                         :null => false
    t.string   "last_name",        :limit => 40
    t.string   "email",            :limit => 60,                         :null => false
    t.string   "image_url",        :limit => 150
    t.integer  "timezone",                        :default => -3,        :null => false
    t.string   "locale",           :limit => 6,   :default => "pt_BR",   :null => false
    t.string   "nikeplus_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "speed_in_km",                     :default => true,      :null => false
    t.boolean  "distance_in_km",                  :default => true,      :null => false
    t.integer  "nikeplus_id",                     :default => 0,         :null => false
    t.string   "screen_name",      :limit => 30
    t.string   "usual_time",                      :default => "morning", :null => false
    t.date     "last_run_day"
    t.string   "token"
    t.datetime "last_manual_sync"
    t.string   "avatar"
    t.float    "total_distance",                  :default => 0.0
    t.boolean  "active",                          :default => true,      :null => false
    t.datetime "last_login"
    t.integer  "login_count",                     :default => 0,         :null => false
  end

  add_index "users", ["active"], :name => "index_users_on_active"
  add_index "users", ["last_run_day"], :name => "index_users_on_last_run_day"
  add_index "users", ["nikeplus_id"], :name => "index_users_on_nikeplus_id"
  add_index "users", ["timezone"], :name => "index_users_on_timezone"
  add_index "users", ["uid"], :name => "index_users_on_uid", :unique => true

end
