# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_06_14_084448) do
  create_table "answers", id: { type: :string, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "course_id", limit: 36, null: false
    t.string "question_id", limit: 36, null: false
    t.string "form_token", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "idx_answer_course"
    t.index ["form_token", "course_id", "question_id"], name: "uniq_answer_token_course_question", unique: true
    t.index ["question_id"], name: "fk_rails_3d5ed4418f"
  end

  create_table "course_departments", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "course_id", limit: 36, null: false
    t.string "department_id", limit: 36, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "department_id"], name: "index_course_departments_on_course_id_and_department_id", unique: true
    t.index ["course_id"], name: "idx_cd_course"
    t.index ["department_id"], name: "fk_rails_cd6259b80b"
  end

  create_table "course_teachers", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "course_id", limit: 36, null: false
    t.string "nameJa", null: false
    t.string "nameEn", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "idx_ct_course"
  end

  create_table "courses", id: { type: :string, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "department_id", limit: 36, null: false
    t.string "course_number", limit: 100, null: false
    t.string "title_ja", null: false
    t.string "title_en", null: false
    t.integer "ocw_id", null: false
    t.integer "year", null: false
    t.integer "start_quarter", null: false
    t.integer "end_quarter", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "idx_course_department"
  end

  create_table "departments", id: { type: :string, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forms", id: { type: :string, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["year"], name: "uniq_form_year", unique: true
  end

  create_table "options", id: { type: :string, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "question_id", limit: 36, null: false
    t.integer "order", null: false
    t.integer "filter_type", null: false
    t.text "text_ja", null: false
    t.text "text_en", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "idx_option_question"
  end

  create_table "questions", id: { type: :string, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "form_id", limit: 36, null: false
    t.string "placeholder_ja", null: false
    t.string "placeholder_en", null: false
    t.integer "filter_type"
    t.integer "order", null: false
    t.text "text_ja", null: false
    t.text "text_en", null: false
    t.text "description_ja", null: false
    t.text "description_en", null: false
    t.text "type", null: false
    t.boolean "require", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_id"], name: "index_questions_on_form_id"
  end

  add_foreign_key "answers", "courses"
  add_foreign_key "answers", "questions"
  add_foreign_key "course_departments", "courses"
  add_foreign_key "course_departments", "departments"
  add_foreign_key "course_teachers", "courses"
  add_foreign_key "courses", "departments", name: "fk_course_department"
  add_foreign_key "options", "questions"
  add_foreign_key "questions", "forms"
end
