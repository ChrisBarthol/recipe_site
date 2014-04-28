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

ActiveRecord::Schema.define(version: 20140428193958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recipe_id"
  end

  add_index "comments", ["recipe_id"], name: "index_comments_on_recipe_id", using: :btree
  add_index "comments", ["user_id", "created_at"], name: "index_comments_on_user_id_and_created_at", using: :btree

  create_table "ingredients", force: true do |t|
    t.string   "name"
    t.string   "quantity"
    t.integer  "recipe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unit"
    t.string   "style"
  end

  add_index "ingredients", ["recipe_id", "name", "quantity"], name: "index_ingredients_on_recipe_id_and_name_and_quantity", using: :btree
  add_index "ingredients", ["style"], name: "index_ingredients_on_style", using: :btree
  add_index "ingredients", ["unit"], name: "index_ingredients_on_unit", using: :btree

  create_table "maderecipes", force: true do |t|
    t.integer  "maker_id"
    t.integer  "maderecipe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "maderecipes", ["maderecipe_id"], name: "index_maderecipes_on_maderecipe_id", using: :btree
  add_index "maderecipes", ["maker_id"], name: "index_maderecipes_on_maker_id", using: :btree

  create_table "makerecipes", force: true do |t|
    t.integer  "maker_id"
    t.integer  "made_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "makerecipes", ["made_id"], name: "index_makerecipes_on_made_id", using: :btree
  add_index "makerecipes", ["maker_id"], name: "index_makerecipes_on_maker_id", using: :btree

  create_table "pantries", force: true do |t|
    t.string   "name"
    t.string   "quantity"
    t.string   "unit"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "expiration"
  end

  add_index "pantries", ["expiration"], name: "index_pantries_on_expiration", using: :btree
  add_index "pantries", ["quantity"], name: "index_pantries_on_quantity", using: :btree
  add_index "pantries", ["unit"], name: "index_pantries_on_unit", using: :btree

  create_table "pantry_items", force: true do |t|
    t.integer  "user_id"
    t.integer  "ingredient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pantry_items", ["ingredient_id"], name: "index_pantry_items_on_ingredient_id", using: :btree
  add_index "pantry_items", ["user_id", "ingredient_id"], name: "index_pantry_items_on_user_id_and_ingredient_id", unique: true, using: :btree
  add_index "pantry_items", ["user_id"], name: "index_pantry_items_on_user_id", using: :btree

  create_table "ratings", force: true do |t|
    t.integer  "ranking"
    t.integer  "user_id"
    t.integer  "recipe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["ranking", "recipe_id"], name: "index_ratings_on_ranking_and_recipe_id", using: :btree
  add_index "ratings", ["ranking", "user_id"], name: "index_ratings_on_ranking_and_user_id", using: :btree

  create_table "reciperelationships", force: true do |t|
    t.integer  "recipesaver_id"
    t.integer  "recipesaved_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reciperelationships", ["recipesaved_id"], name: "index_reciperelationships_on_recipesaved_id", using: :btree
  add_index "reciperelationships", ["recipesaver_id", "recipesaved_id"], name: "index_reciperelationships_on_recipesaver_id_and_recipesaved_id", unique: true, using: :btree
  add_index "reciperelationships", ["recipesaver_id"], name: "index_reciperelationships_on_recipesaver_id", using: :btree

  create_table "recipes", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.text     "direction"
    t.integer  "fork_id"
    t.string   "recipeimage"
    t.integer  "serving"
    t.string   "preptime"
    t.string   "totaltime"
    t.string   "nutrition"
    t.integer  "rating"
  end

  add_index "recipes", ["name"], name: "index_recipes_on_name", unique: true, using: :btree
  add_index "recipes", ["preptime"], name: "index_recipes_on_preptime", using: :btree
  add_index "recipes", ["rating"], name: "index_recipes_on_rating", using: :btree
  add_index "recipes", ["serving"], name: "index_recipes_on_serving", using: :btree
  add_index "recipes", ["totaltime"], name: "index_recipes_on_totaltime", using: :btree
  add_index "recipes", ["user_id"], name: "index_recipes_on_user_id", using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
