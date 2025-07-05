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

ActiveRecord::Schema[7.1].define(version: 2025_07_05_104610) do
  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "contact_person"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "estimates", force: :cascade do |t|
    t.integer "client_id", null: false
    t.date "issue_date"
    t.date "expiry_date"
    t.decimal "amount", precision: 10, scale: 2
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "direction"
    t.string "subject"
    t.index ["client_id"], name: "index_estimates_on_client_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "client_id", null: false
    t.date "issue_date"
    t.date "due_date"
    t.decimal "amount", precision: 10, scale: 2
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject"
    t.string "direction"
    t.index ["client_id"], name: "index_invoices_on_client_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "invoice_id", null: false
    t.date "payment_date"
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_payments_on_invoice_id"
  end

  add_foreign_key "estimates", "clients"
  add_foreign_key "invoices", "clients"
  add_foreign_key "payments", "invoices"
end
