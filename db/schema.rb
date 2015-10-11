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

ActiveRecord::Schema.define(version: 20150927193524) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "administrators", force: :cascade do |t|
    t.string   "name"
    t.boolean  "main",                   default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "administrators", ["confirmation_token"], name: "index_administrators_on_confirmation_token", unique: true, using: :btree
  add_index "administrators", ["email"], name: "index_administrators_on_email", unique: true, using: :btree
  add_index "administrators", ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true, using: :btree

  create_table "answered_questionnaires", force: :cascade do |t|
    t.integer  "status",                                     default: 0,   null: false
    t.decimal  "points",           precision: 15, scale: 10, default: 0.0, null: false
    t.integer  "questionnaire_id"
    t.integer  "student_id"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
  end

  add_index "answered_questionnaires", ["questionnaire_id"], name: "index_answered_questionnaires_on_questionnaire_id", using: :btree
  add_index "answered_questionnaires", ["student_id"], name: "index_answered_questionnaires_on_student_id", using: :btree

  create_table "answers", force: :cascade do |t|
    t.integer  "question_option_id"
    t.integer  "answered_questionnaire_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "answers", ["answered_questionnaire_id"], name: "index_answers_on_answered_questionnaire_id", using: :btree
  add_index "answers", ["question_option_id"], name: "index_answers_on_question_option_id", using: :btree

  create_table "classrooms", force: :cascade do |t|
    t.string   "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "question_options", force: :cascade do |t|
    t.text     "description"
    t.boolean  "right",       default: false, null: false
    t.integer  "question_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "question_options", ["question_id"], name: "index_question_options_on_question_id", using: :btree

  create_table "questionnaires", force: :cascade do |t|
    t.string   "title"
    t.boolean  "published",    default: false, null: false
    t.integer  "teacher_id"
    t.integer  "classroom_id"
    t.integer  "subject_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "questionnaires", ["classroom_id"], name: "index_questionnaires_on_classroom_id", using: :btree
  add_index "questionnaires", ["subject_id"], name: "index_questionnaires_on_subject_id", using: :btree
  add_index "questionnaires", ["teacher_id"], name: "index_questionnaires_on_teacher_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.text     "description"
    t.integer  "index",                  default: 0, null: false
    t.integer  "questionnaire_id"
    t.integer  "question_options_count"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "questions", ["questionnaire_id"], name: "index_questions_on_questionnaire_id", using: :btree

  create_table "students", force: :cascade do |t|
    t.string   "name"
    t.integer  "gender",                 default: 0,  null: false
    t.string   "email",                  default: "", null: false
    t.string   "cpf"
    t.string   "phone"
    t.date     "birth_date"
    t.integer  "classroom_id"
    t.integer  "status",                 default: 0,  null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "students", ["classroom_id"], name: "index_students_on_classroom_id", using: :btree
  add_index "students", ["confirmation_token"], name: "index_students_on_confirmation_token", unique: true, using: :btree
  add_index "students", ["email"], name: "index_students_on_email", unique: true, using: :btree
  add_index "students", ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true, using: :btree

  create_table "subjects", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "teacher_classroom_subjects", force: :cascade do |t|
    t.integer "classroom_id"
    t.integer "teacher_id"
    t.integer "subject_id"
  end

  add_index "teacher_classroom_subjects", ["classroom_id"], name: "index_teacher_classroom_subjects_on_classroom_id", using: :btree
  add_index "teacher_classroom_subjects", ["subject_id"], name: "index_teacher_classroom_subjects_on_subject_id", using: :btree
  add_index "teacher_classroom_subjects", ["teacher_id"], name: "index_teacher_classroom_subjects_on_teacher_id", using: :btree

  create_table "teachers", force: :cascade do |t|
    t.string   "name"
    t.integer  "gender",                 default: 0,  null: false
    t.string   "email",                  default: "", null: false
    t.string   "cpf"
    t.string   "phone"
    t.date     "birth_date"
    t.integer  "status",                 default: 0,  null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "teachers", ["confirmation_token"], name: "index_teachers_on_confirmation_token", unique: true, using: :btree
  add_index "teachers", ["email"], name: "index_teachers_on_email", unique: true, using: :btree
  add_index "teachers", ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "students", "classrooms"
end
