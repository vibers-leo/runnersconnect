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

ActiveRecord::Schema[8.1].define(version: 2026_03_08_000004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "subtotal", precision: 10, scale: 2, null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id", "product_id"], name: "index_cart_items_on_cart_id_and_product_id", unique: true
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "crawl_sources", force: :cascade do |t|
    t.string "name", null: false
    t.string "base_url", null: false
    t.string "crawler_class", null: false
    t.boolean "enabled", default: true, null: false
    t.datetime "last_crawled_at"
    t.integer "crawl_interval_hours", default: 24, null: false
    t.text "last_error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crew_contact_points", force: :cascade do |t|
    t.bigint "crew_id", null: false
    t.integer "platform", default: 0, null: false
    t.string "url", null: false
    t.string "label", null: false
    t.boolean "primary", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crew_id", "platform"], name: "index_crew_contact_points_on_crew_id_and_platform"
    t.index ["crew_id"], name: "index_crew_contact_points_on_crew_id"
  end

  create_table "crews", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "leader_id", null: false
    t.string "name"
    t.string "slug"
    t.string "short_description"
    t.string "region"
    t.integer "founded_year"
    t.integer "member_count_estimate"
    t.string "activity_schedule"
    t.string "activity_location"
    t.integer "status", default: 0, null: false
    t.boolean "featured", default: false, null: false
    t.string "website_url"
    t.datetime "published_at"
    t.integer "views_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_crews_on_code"
    t.index ["featured"], name: "index_crews_on_featured"
    t.index ["leader_id"], name: "index_crews_on_leader_id"
    t.index ["region"], name: "index_crews_on_region"
    t.index ["slug"], name: "index_crews_on_slug", unique: true
    t.index ["status"], name: "index_crews_on_status"
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.decimal "subtotal", precision: 10, scale: 2, null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "order_number", null: false
    t.bigint "race_id", null: false
    t.text "shipping_address"
    t.string "shipping_phone"
    t.string "status", default: "pending", null: false
    t.decimal "total_amount", precision: 10, scale: 2, default: "0.0"
    t.string "tracking_number"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["order_number"], name: "index_orders_on_order_number", unique: true
    t.index ["race_id", "status"], name: "index_orders_on_race_id_and_status"
    t.index ["race_id"], name: "index_orders_on_race_id"
    t.index ["status"], name: "index_orders_on_status"
    t.index ["user_id", "status"], name: "index_orders_on_user_id_and_status"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "organizer_profiles", force: :cascade do |t|
    t.string "account_holder"
    t.string "bank_account"
    t.string "bank_name"
    t.string "business_name", null: false
    t.string "contact_email"
    t.string "contact_phone"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "total_participants_count", default: 0
    t.integer "total_races_count", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_organizer_profiles_on_user_id", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.bigint "race_id", null: false
    t.string "size"
    t.string "status", default: "active", null: false
    t.integer "stock", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["race_id", "status", "stock"], name: "index_products_on_race_id_status_and_stock"
    t.index ["race_id"], name: "index_products_on_race_id"
    t.index ["status"], name: "index_products_on_status"
  end

  create_table "race_editions", force: :cascade do |t|
    t.integer "age_limit_max"
    t.integer "age_limit_min"
    t.integer "capacity", default: 0
    t.datetime "created_at", null: false
    t.integer "current_count", default: 0
    t.integer "display_order", default: 1
    t.float "distance"
    t.boolean "is_sold_out", default: false
    t.string "name", null: false
    t.integer "price", default: 0, null: false
    t.bigint "race_id", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_race_editions_on_race_id"
  end

  create_table "races", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "is_official_record", default: true
    t.string "location"
    t.string "official_site_url"
    t.bigint "organizer_id"
    t.string "organizer_name"
    t.datetime "refund_deadline"
    t.datetime "registration_end_at"
    t.datetime "registration_start_at"
    t.datetime "start_at", null: false
    t.string "status", default: "draft"
    t.string "thumbnail_url"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["organizer_id"], name: "index_races_on_organizer_id"
    t.index ["status", "start_at"], name: "index_races_on_status_and_start_at"
  end

  create_table "records", force: :cascade do |t|
    t.string "certificate_url"
    t.datetime "created_at", null: false
    t.string "gun_time"
    t.boolean "is_verified", default: true
    t.string "net_time"
    t.jsonb "photo_urls"
    t.bigint "race_edition_id", null: false
    t.integer "rank_age"
    t.integer "rank_gender"
    t.integer "rank_overall"
    t.bigint "registration_id"
    t.jsonb "splits"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["race_edition_id", "net_time"], name: "index_records_on_race_edition_id_and_net_time"
    t.index ["race_edition_id"], name: "index_records_on_race_edition_id"
    t.index ["registration_id"], name: "index_records_on_registration_id"
    t.index ["user_id", "race_edition_id"], name: "index_records_on_user_id_and_race_edition_id", unique: true
    t.index ["user_id"], name: "index_records_on_user_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.string "bib_number"
    t.datetime "created_at", null: false
    t.integer "crew_id"
    t.string "emergency_contact"
    t.datetime "medal_received_at"
    t.string "medal_received_by"
    t.string "merchant_uid", null: false
    t.datetime "paid_at"
    t.integer "payment_amount"
    t.string "payment_method"
    t.string "qr_token"
    t.bigint "race_edition_id", null: false
    t.string "shipping_address"
    t.string "shipping_address_detail"
    t.jsonb "shipping_address_snapshot"
    t.text "shipping_memo"
    t.string "shipping_phone"
    t.string "shipping_status", default: "preparing"
    t.string "shipping_zipcode"
    t.datetime "souvenir_received_at"
    t.string "souvenir_received_by"
    t.string "status", default: "pending"
    t.string "tracking_number"
    t.string "tshirt_size"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["crew_id"], name: "index_registrations_on_crew_id"
    t.index ["medal_received_at"], name: "index_registrations_on_medal_received_at"
    t.index ["merchant_uid"], name: "index_registrations_on_merchant_uid", unique: true
    t.index ["race_edition_id", "status"], name: "index_registrations_on_edition_and_status"
    t.index ["race_edition_id"], name: "index_registrations_on_race_edition_id"
    t.index ["souvenir_received_at"], name: "index_registrations_on_souvenir_received_at"
    t.index ["status", "created_at"], name: "index_registrations_on_status_and_created_at"
    t.index ["user_id", "race_edition_id"], name: "index_registrations_on_user_id_and_race_edition_id", unique: true
    t.index ["user_id"], name: "index_registrations_on_user_id"
  end

  create_table "settlements", force: :cascade do |t|
    t.text "admin_memo"
    t.datetime "approved_at"
    t.datetime "created_at", null: false
    t.decimal "organizer_payout", precision: 15, scale: 2, default: "0.0"
    t.bigint "organizer_profile_id", null: false
    t.datetime "paid_at"
    t.decimal "platform_commission", precision: 15, scale: 2, default: "0.0"
    t.bigint "race_id", null: false
    t.integer "registration_count", default: 0
    t.datetime "requested_at"
    t.string "status", default: "pending", null: false
    t.decimal "total_revenue", precision: 15, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
    t.index ["organizer_profile_id", "race_id"], name: "index_settlements_on_organizer_profile_id_and_race_id", unique: true
    t.index ["organizer_profile_id"], name: "index_settlements_on_organizer_profile_id"
    t.index ["race_id"], name: "index_settlements_on_race_id"
    t.index ["status"], name: "index_settlements_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "address_basic"
    t.string "address_detail"
    t.string "address_zipcode"
    t.string "age_group"
    t.date "birth_date"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "emergency_contact"
    t.string "encrypted_password", default: "", null: false
    t.string "gender"
    t.string "jti", null: false
    t.string "name", null: false
    t.string "nickname"
    t.boolean "onboarding_completed", default: false, null: false
    t.string "phone_number"
    t.string "preferred_size"
    t.string "provider"
    t.string "region"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "user"
    t.float "total_distance", default: 0.0
    t.integer "total_races", default: 0
    t.string "uid"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["gender", "age_group"], name: "index_users_on_gender_and_age_group"
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "external_races", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.date "race_date", null: false
    t.date "race_end_date"
    t.string "location"
    t.string "source_url", null: false
    t.string "source_name", null: false
    t.string "registration_url"
    t.date "registration_deadline"
    t.string "distances", default: [], array: true
    t.string "fee_info"
    t.string "organizer_name"
    t.string "image_url"
    t.integer "status", default: 0, null: false
    t.datetime "crawled_at"
    t.jsonb "raw_data", default: {}
    t.string "content_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_date"], name: "index_external_races_on_race_date"
    t.index ["source_name"], name: "index_external_races_on_source_name"
    t.index ["source_url"], name: "index_external_races_on_source_url", unique: true
    t.index ["status"], name: "index_external_races_on_status"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "carts", "users"
  add_foreign_key "crew_contact_points", "crews"
  add_foreign_key "crews", "users", column: "leader_id"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "races"
  add_foreign_key "orders", "users"
  add_foreign_key "organizer_profiles", "users"
  add_foreign_key "products", "races"
  add_foreign_key "race_editions", "races"
  add_foreign_key "races", "organizer_profiles", column: "organizer_id"
  add_foreign_key "records", "race_editions"
  add_foreign_key "records", "users"
  add_foreign_key "registrations", "race_editions"
  add_foreign_key "registrations", "users"
  add_foreign_key "settlements", "organizer_profiles"
  add_foreign_key "settlements", "races"
end
