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

ActiveRecord::Schema.define(version: 20161214020129) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "JOBマスタ", id: false, force: :cascade do |t|
    t.string   "job番号",      null: false
    t.string   "job名"
    t.date     "開始日"
    t.date     "終了日"
    t.string   "ユーザ番号"
    t.string   "ユーザ名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "入力社員番号"
    t.string   "分類コード"
    t.string   "分類名"
    t.string   "関連Job番号"
    t.string   "備考"
  end

  add_index "JOBマスタ", ["job番号"], name: "index_JOBマスタ_on_job番号", unique: true, using: :btree

  create_table "MYJOBマスタ", id: false, force: :cascade do |t|
    t.string   "社員番号",       null: false
    t.string   "job番号",      null: false
    t.string   "job名"
    t.date     "開始日"
    t.date     "終了日"
    t.string   "ユーザ番号"
    t.string   "ユーザ名"
    t.string   "入力社員番号"
    t.string   "分類コード"
    t.string   "分類名"
    t.string   "関連Job番号"
    t.string   "備考"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "MY場所マスタ", id: false, force: :cascade do |t|
    t.string   "社員番号",       null: false
    t.string   "場所コード",      null: false
    t.string   "場所名"
    t.string   "場所名カナ"
    t.string   "SUB"
    t.string   "場所区分"
    t.string   "会社コード"
    t.datetime "更新日"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "社員番号"
    t.string   "開始"
    t.string   "終了"
    t.string   "状態コード"
    t.string   "場所コード"
    t.string   "JOB"
    t.string   "所属コード"
    t.string   "工程コード"
    t.string   "工数"
    t.string   "計上"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "有無"
  end

  create_table "jpt_holiday_msts", force: :cascade do |t|
    t.date     "event_date"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "keihi_bodies", force: :cascade do |t|
    t.string   "申請番号"
    t.date     "日付"
    t.string   "社員番号"
    t.string   "相手先"
    t.string   "機関名"
    t.string   "発"
    t.string   "着"
    t.string   "発着kubun"
    t.string   "交通費"
    t.string   "日当"
    t.string   "宿泊費"
    t.string   "その他"
    t.string   "JOB"
    t.text     "備考"
    t.string   "領収書kubun"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keihi_heads", id: false, force: :cascade do |t|
    t.string   "申請番号",       null: false
    t.date     "日付"
    t.string   "社員番号"
    t.string   "申請者"
    t.string   "交通費合計"
    t.string   "日当合計"
    t.string   "宿泊費合計"
    t.string   "その他合計"
    t.string   "旅費合計"
    t.string   "仮払金"
    t.string   "合計"
    t.string   "支給品"
    t.string   "過不足"
    t.string   "承認kubun"
    t.string   "承認者"
    t.date     "清算予定日"
    t.date     "清算日"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "承認済区分"
  end

  add_index "keihi_heads", ["申請番号"], name: "index_keihi_heads_on_申請番号", unique: true, using: :btree

  create_table "kintais", force: :cascade do |t|
    t.date     "日付"
    t.string   "曜日"
    t.string   "勤務タイプ"
    t.decimal  "実労働時間"
    t.decimal  "普通残業時間"
    t.decimal  "深夜残業時間"
    t.decimal  "普通保守時間"
    t.decimal  "深夜保守時間"
    t.integer  "保守携帯回数"
    t.string   "状態1"
    t.string   "状態2"
    t.string   "状態3"
    t.text     "備考"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "社員番号"
    t.string   "入力済"
    t.string   "holiday"
    t.date     "代休相手日付"
    t.string   "代休取得区分"
    t.datetime "出勤時刻"
    t.datetime "退社時刻"
    t.decimal  "遅刻時間"
    t.decimal  "早退時間"
  end

  create_table "setsubiyoyakus", force: :cascade do |t|
    t.string   "設備コード"
    t.string   "社員番号"
    t.string   "相手先"
    t.string   "開始"
    t.string   "終了"
    t.text     "用件"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "setting_tables", force: :cascade do |t|
    t.string   "社員番号",       null: false
    t.string   "scrolltime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "local"
  end

  create_table "temps", force: :cascade do |t|
    t.date    "date"
    t.boolean "checked"
  end

  create_table "ロールマスタ", force: :cascade do |t|
    t.string   "ロールコード",     limit: 10, null: false
    t.string   "ロール名",       limit: 40
    t.string   "序列",         limit: 10
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "ロールマスタ", ["ロールコード"], name: "index_ロールマスタ_on_ロールコード", using: :btree

  create_table "ロールメンバ", force: :cascade do |t|
    t.string   "ロールコード",     limit: 10, null: false
    t.string   "社員番号",       limit: 10, null: false
    t.string   "氏名"
    t.string   "ロール内序列",     limit: 10
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "ロールメンバ", ["ロールコード"], name: "index_ロールメンバ_on_ロールコード", using: :btree

  create_table "会社マスタ", id: false, force: :cascade do |t|
    t.string   "会社コード",      null: false
    t.string   "会社名"
    t.text     "備考"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "会社マスタ", ["会社コード"], name: "index_会社マスタ_on_会社コード", unique: true, using: :btree

  create_table "伝言", force: :cascade do |t|
    t.string   "from1"
    t.string   "from2"
    t.datetime "日付"
    t.string   "入力者"
    t.string   "用件"
    t.string   "回答"
    t.string   "伝言内容"
    t.boolean  "確認"
    t.boolean  "送信"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "社員番号"
  end

  create_table "伝言回答マスタ", force: :cascade do |t|
    t.string   "種類名"
    t.string   "備考"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "伝言用件マスタ", force: :cascade do |t|
    t.string   "種類名"
    t.string   "備考"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "優先さ"
  end

  create_table "優先", force: :cascade do |t|
    t.integer  "優先さ"
    t.string   "名前"
    t.string   "色"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "分類マスタ", id: false, force: :cascade do |t|
    t.string   "分類コード",      null: false
    t.string   "分類名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "分類マスタ", ["分類コード"], name: "index_分類マスタ_on_分類コード", unique: true, using: :btree

  create_table "回覧", force: :cascade do |t|
    t.string   "発行者"
    t.string   "要件"
    t.string   "開始"
    t.string   "終了"
    t.string   "件名"
    t.text     "内容"
    t.boolean  "確認"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "確認要"
    t.boolean  "確認済"
  end

  create_table "回覧用件マスタ", force: :cascade do |t|
    t.string   "名称"
    t.string   "備考"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "優先さ"
  end

  create_table "回覧詳細", force: :cascade do |t|
    t.string   "回覧コード"
    t.string   "対象者"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "状態"
  end

  create_table "場所マスタ", id: false, force: :cascade do |t|
    t.string   "場所コード",      null: false
    t.string   "場所名"
    t.string   "場所名カナ"
    t.string   "SUB"
    t.string   "場所区分"
    t.string   "会社コード"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "場所マスタ", ["場所コード"], name: "index_場所マスタ_on_場所コード", unique: true, using: :btree

  create_table "場所区分マスタ", id: false, force: :cascade do |t|
    t.string   "場所区分コード",    null: false
    t.string   "場所区分名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "場所区分マスタ", ["場所区分コード"], name: "index_場所区分マスタ_on_場所区分コード", unique: true, using: :btree

  create_table "工程マスタ", id: false, force: :cascade do |t|
    t.string   "所属コード",      null: false
    t.string   "工程コード",      null: false
    t.string   "工程名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "工程マスタ", ["所属コード", "工程コード"], name: "index_工程マスタ_on_所属コード_and_工程コード", unique: true, using: :btree

  create_table "役職マスタ", id: false, force: :cascade do |t|
    t.string   "役職コード",      null: false
    t.string   "役職名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "役職マスタ", ["役職コード"], name: "index_役職マスタ_on_役職コード", unique: true, using: :btree

  create_table "所在マスタ", id: false, force: :cascade do |t|
    t.string   "所在コード",      null: false
    t.string   "所在名"
    t.string   "背景色"
    t.string   "文字色"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "所在マスタ", ["所在コード"], name: "index_所在マスタ_on_所在コード", unique: true, using: :btree

  create_table "所属マスタ", id: false, force: :cascade do |t|
    t.string   "所属コード",      null: false
    t.string   "所属名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "所属マスタ", ["所属コード"], name: "index_所属マスタ_on_所属コード", unique: true, using: :btree

  create_table "承認者マスタ", force: :cascade do |t|
    t.string   "申請者"
    t.string   "承認者"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "順番"
  end

  add_index "承認者マスタ", ["承認者", "申請者"], name: "index_承認者マスタ_on_承認者_and_申請者", using: :btree

  create_table "担当者マスタ", id: false, force: :cascade do |t|
    t.string   "担当者コード",                              null: false
    t.string   "担当者名称"
    t.boolean  "admin",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "supervisor",          default: false
  end

  add_index "担当者マスタ", ["担当者コード"], name: "index_担当者マスタ_on_担当者コード", unique: true, using: :btree

  create_table "機関マスタ", id: false, force: :cascade do |t|
    t.string   "機関コード",      null: false
    t.string   "機関名"
    t.text     "備考"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "機関マスタ", ["機関コード"], name: "index_機関マスタ_on_機関コード", unique: true, using: :btree

  create_table "状態マスタ", id: false, force: :cascade do |t|
    t.string   "状態コード",      null: false
    t.string   "状態名"
    t.string   "状態区分"
    t.string   "勤怠状態名"
    t.string   "マーク"
    t.string   "色"
    t.string   "文字色"
    t.string   "WEB使用区分"
    t.string   "勤怠使用区分"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "状態マスタ", ["状態コード"], name: "index_状態マスタ_on_状態コード", unique: true, using: :btree

  create_table "社員マスタ", id: false, force: :cascade do |t|
    t.string   "社員番号",                       null: false
    t.string   "連携用社員番号"
    t.string   "氏名"
    t.string   "所属コード"
    t.string   "直間区分"
    t.string   "役職コード"
    t.string   "内線電話番号"
    t.string   "伝言件数"
    t.string   "回覧件数"
    t.string   "所在コード"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.decimal  "有給残数"
    t.string   "残業区分"
    t.string   "勤務タイプ"
    t.boolean  "区分",         default: false
    t.boolean  "タイムライン区分",   default: false
    t.date     "login_time"
    t.integer  "序列",         default: 0
    t.string   "デフォルトロール"
  end

  add_index "社員マスタ", ["社員番号"], name: "index_社員マスタ_on_社員番号", unique: true, using: :btree

  create_table "設備マスタ", force: :cascade do |t|
    t.string   "設備コード"
    t.string   "設備名"
    t.string   "備考"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "設備マスタ", ["設備コード"], name: "index_設備マスタ_on_設備コード", unique: true, using: :btree

  create_table "設備予約", force: :cascade do |t|
    t.string   "設備コード"
    t.string   "開始"
    t.string   "終了"
    t.string   "予約者"
    t.string   "相手先"
    t.text     "用件"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "通信制御マスタ", force: :cascade do |t|
    t.string   "社員番号"
    t.string   "メール"
    t.string   "送信許可区分"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "駅マスタ", id: false, force: :cascade do |t|
    t.string   "駅コード",       null: false
    t.string   "駅名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "駅名カナ"
    t.integer  "選択回数"
  end

  add_index "駅マスタ", ["駅コード"], name: "index_駅マスタ_on_駅コード", unique: true, using: :btree

end
