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

ActiveRecord::Schema.define(version: 20151227110430) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branches", force: :cascade do |t|
    t.integer  "repository_id"
    t.string   "name"
    t.boolean  "active",        default: true
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "deployments", force: :cascade do |t|
    t.integer  "release_id"
    t.integer  "environment_id"
    t.integer  "status_id"
    t.string   "notification_list"
    t.string   "dev"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "deployments", ["created_at"], name: "index_deployments_on_created_at", using: :btree
  add_index "deployments", ["dev"], name: "index_deployments_on_dev", using: :btree
  add_index "deployments", ["environment_id", "created_at"], name: "index_deployments_on_environment_id_and_created_at", using: :btree
  add_index "deployments", ["environment_id"], name: "index_deployments_on_environment_id", using: :btree
  add_index "deployments", ["notification_list"], name: "index_deployments_on_notification_list", using: :btree
  add_index "deployments", ["release_id"], name: "index_deployments_on_release_id", using: :btree
  add_index "deployments", ["status_id"], name: "index_deployments_on_status_id", using: :btree

  create_table "environments", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "operation_logs", force: :cascade do |t|
    t.string   "username"
    t.integer  "status_id"
    t.integer  "deployment_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "operation_logs", ["status_id"], name: "index_operation_logs_on_status_id", using: :btree
  add_index "operation_logs", ["username"], name: "index_operation_logs_on_username", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer  "deployment_id"
    t.integer  "branch_id"
    t.string   "sha"
    t.text     "deployment_instruction"
    t.text     "rollback_instruction"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "projects", ["branch_id"], name: "index_projects_on_branch_id", using: :btree
  add_index "projects", ["deployment_id"], name: "index_projects_on_deployment_id", using: :btree

  create_table "releases", force: :cascade do |t|
    t.string   "name"
    t.string   "summary"
    t.integer  "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "releases", ["created_at"], name: "index_releases_on_created_at", using: :btree
  add_index "releases", ["name"], name: "index_releases_on_name", using: :btree
  add_index "releases", ["status_id"], name: "index_releases_on_status_id", using: :btree
  add_index "releases", ["summary"], name: "index_releases_on_summary", using: :btree

  create_table "repositories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "github_login"
    t.string   "name"
    t.string   "slack_username"
    t.string   "remember_token"
    t.string   "avatar_url"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "users", ["github_login"], name: "index_users_on_github_login", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
