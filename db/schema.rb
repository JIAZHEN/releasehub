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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161214173338) do

  create_table "branches", force: :cascade do |t|
    t.integer  "repository_id", limit: 4
    t.string   "name",          limit: 255
    t.boolean  "active",                    default: true
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "deployments", force: :cascade do |t|
    t.integer  "release_id",        limit: 4
    t.integer  "environment_id",    limit: 4
    t.integer  "status_id",         limit: 4
    t.string   "notification_list", limit: 255
    t.string   "dev",               limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "deployments", ["created_at"], name: "index_deployments_on_created_at", using: :btree
  add_index "deployments", ["dev"], name: "index_deployments_on_dev", using: :btree
  add_index "deployments", ["environment_id", "created_at"], name: "index_deployments_on_environment_id_and_created_at", using: :btree
  add_index "deployments", ["environment_id"], name: "index_deployments_on_environment_id", using: :btree
  add_index "deployments", ["notification_list"], name: "index_deployments_on_notification_list", using: :btree
  add_index "deployments", ["release_id"], name: "index_deployments_on_release_id", using: :btree
  add_index "deployments", ["status_id"], name: "index_deployments_on_status_id", using: :btree

  create_table "environments", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "operation_logs", force: :cascade do |t|
    t.string   "username",      limit: 255
    t.integer  "status_id",     limit: 4
    t.integer  "deployment_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "operation_logs", ["status_id"], name: "index_operation_logs_on_status_id", using: :btree
  add_index "operation_logs", ["username"], name: "index_operation_logs_on_username", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer  "deployment_id",          limit: 4
    t.integer  "branch_id",              limit: 4
    t.string   "sha",                    limit: 255
    t.text     "deployment_instruction", limit: 65535
    t.text     "rollback_instruction",   limit: 65535
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "deployment_order",       limit: 4
  end

  add_index "projects", ["branch_id"], name: "index_projects_on_branch_id", using: :btree
  add_index "projects", ["deployment_id"], name: "index_projects_on_deployment_id", using: :btree

  create_table "releases", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "summary",    limit: 255
    t.integer  "status_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "releases", ["created_at"], name: "index_releases_on_created_at", using: :btree
  add_index "releases", ["name"], name: "index_releases_on_name", using: :btree
  add_index "releases", ["status_id"], name: "index_releases_on_status_id", using: :btree
  add_index "releases", ["summary"], name: "index_releases_on_summary", using: :btree

  create_table "repositories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "github_login",   limit: 255
    t.string   "name",           limit: 255
    t.string   "slack_username", limit: 255
    t.string   "remember_token", limit: 255
    t.string   "avatar_url",     limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "users", ["github_login"], name: "index_users_on_github_login", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
