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

ActiveRecord::Schema.define(:version => 20131109094612) do

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "role",                           :default => "comments"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "exam_questions", :force => true do |t|
    t.text     "question_prompt"
    t.integer  "objective_id"
    t.integer  "creator_id"
    t.text     "educational_purpose"
    t.integer  "medical_case_id"
    t.string   "correct_answer"
    t.text     "correct_answer_explanation"
    t.string   "incorrect_1"
    t.text     "incorrect_1_explanation"
    t.string   "status",                     :default => "approved"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.decimal  "average_rating",             :default => 0.0,        :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "position"
    t.decimal  "total_ratings",              :default => 0.0
  end

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "medical_case_id"
    t.boolean  "is_active",        :default => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "exam_question_id"
  end

  create_table "forem_categories", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "slug"
  end

  add_index "forem_categories", ["slug"], :name => "index_forem_categories_on_slug", :unique => true

  create_table "forem_forums", :force => true do |t|
    t.string  "name"
    t.text    "description"
    t.integer "category_id"
    t.integer "views_count", :default => 0
    t.string  "slug"
  end

  add_index "forem_forums", ["slug"], :name => "index_forem_forums_on_slug", :unique => true

  create_table "forem_groups", :force => true do |t|
    t.string "name"
  end

  add_index "forem_groups", ["name"], :name => "index_forem_groups_on_name"

  create_table "forem_memberships", :force => true do |t|
    t.integer "group_id"
    t.integer "member_id"
  end

  add_index "forem_memberships", ["group_id"], :name => "index_forem_memberships_on_group_id"

  create_table "forem_moderator_groups", :force => true do |t|
    t.integer "forum_id"
    t.integer "group_id"
  end

  add_index "forem_moderator_groups", ["forum_id"], :name => "index_forem_moderator_groups_on_forum_id"

  create_table "forem_posts", :force => true do |t|
    t.integer  "topic_id"
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "reply_to_id"
    t.string   "state",       :default => "pending_review"
    t.boolean  "notified",    :default => false
  end

  add_index "forem_posts", ["reply_to_id"], :name => "index_forem_posts_on_reply_to_id"
  add_index "forem_posts", ["state"], :name => "index_forem_posts_on_state"
  add_index "forem_posts", ["topic_id"], :name => "index_forem_posts_on_topic_id"
  add_index "forem_posts", ["user_id"], :name => "index_forem_posts_on_user_id"

  create_table "forem_subscriptions", :force => true do |t|
    t.integer "subscriber_id"
    t.integer "topic_id"
  end

  create_table "forem_topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "subject"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.boolean  "locked",       :default => false,            :null => false
    t.boolean  "pinned",       :default => false
    t.boolean  "hidden",       :default => false
    t.datetime "last_post_at"
    t.string   "state",        :default => "pending_review"
    t.integer  "views_count",  :default => 0
    t.string   "slug"
  end

  add_index "forem_topics", ["forum_id"], :name => "index_forem_topics_on_forum_id"
  add_index "forem_topics", ["slug"], :name => "index_forem_topics_on_slug", :unique => true
  add_index "forem_topics", ["state"], :name => "index_forem_topics_on_state"
  add_index "forem_topics", ["user_id"], :name => "index_forem_topics_on_user_id"

  create_table "forem_views", :force => true do |t|
    t.integer  "user_id"
    t.integer  "viewable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count",             :default => 0
    t.string   "viewable_type"
    t.datetime "current_viewed_at"
    t.datetime "past_viewed_at"
  end

  add_index "forem_views", ["updated_at"], :name => "index_forem_views_on_updated_at"
  add_index "forem_views", ["user_id"], :name => "index_forem_views_on_user_id"
  add_index "forem_views", ["viewable_id"], :name => "index_forem_views_on_topic_id"

  create_table "imagings", :force => true do |t|
    t.integer  "medical_case_id"
    t.string   "result"
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "incorrect_answers", :force => true do |t|
    t.integer  "exam_question_id"
    t.string   "answer"
    t.text     "explanation"
    t.integer  "seqence"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "invites", :force => true do |t|
    t.string   "email",                     :default => "",    :null => false
    t.integer  "role_id"
    t.string   "invitation_token"
    t.boolean  "status",                    :default => false
    t.integer  "invitor_id"
    t.integer  "medical_organization_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "invitor_name"
    t.string   "medical_organization_name"
    t.string   "role_name"
  end

  add_index "invites", ["email"], :name => "index_invites_on_email", :unique => true
  add_index "invites", ["invitation_token"], :name => "index_invites_on_invitation_token", :unique => true

  create_table "labs", :force => true do |t|
    t.integer  "medical_case_id"
    t.string   "result"
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "medical_cases", :force => true do |t|
    t.string   "title"
    t.integer  "age"
    t.string   "gender"
    t.text     "chief_complaint"
    t.text     "history_of_present_illness"
    t.integer  "creator_id"
    t.string   "status"
    t.text     "educational_objective"
    t.decimal  "average_rating",             :default => 0.0, :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "race_id"
  end

  create_table "medical_histories", :force => true do |t|
    t.integer  "medical_case_id"
    t.text     "medication"
    t.text     "allergies"
    t.text     "past_medical_history"
    t.text     "family_history"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "medical_organizations", :force => true do |t|
    t.string   "name",        :limit => 75,                    :null => false
    t.boolean  "status",                    :default => false, :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "users_count",               :default => 0
  end

  add_index "medical_organizations", ["name"], :name => "index_medical_organizations_on_name", :unique => true

  create_table "objectives", :force => true do |t|
    t.string   "name",                    :limit => 75,                    :null => false
    t.boolean  "suspended",                             :default => false
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "hide_author",                           :default => false
    t.boolean  "hide_feedback",                         :default => false
    t.string   "situation"
    t.text     "description"
    t.integer  "medical_organization_id"
  end

  create_table "other_studies", :force => true do |t|
    t.integer  "medical_case_id"
    t.string   "result"
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "questions", :force => true do |t|
    t.integer  "medical_case_id"
    t.text     "question_prompt"
    t.string   "correct_answer"
    t.string   "correct_answer_explanation"
    t.string   "incorrect_answer_1"
    t.string   "incorrect_answer_1_explanation"
    t.string   "incorrect_answer_2"
    t.string   "incorrect_answer_2_explanation"
    t.string   "incorrect_answer_3"
    t.string   "incorrect_answer_3_explanation"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "races", :force => true do |t|
    t.string   "name",       :limit => 75,                   :null => false
    t.boolean  "status",                   :default => true, :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "medical_case_id"
    t.decimal  "rate",             :default => 0.0, :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "exam_question_id"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "medical_case_id"
    t.decimal  "temperature"
    t.decimal  "heart_rate"
    t.decimal  "blood_pressure"
    t.decimal  "respiratory_rate"
    t.decimal  "spo2"
    t.text     "physical_exam_description"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "score_boards", :force => true do |t|
    t.integer  "user_id"
    t.integer  "medical_case_id"
    t.boolean  "correct"
    t.string   "status"
    t.string   "answer"
    t.string   "time_taken"
    t.string   "exam_mode"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "exam_number",      :default => 1, :null => false
    t.integer  "attempt",          :default => 1, :null => false
    t.integer  "exam_question_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "specific_exam_details", :force => true do |t|
    t.integer  "review_id"
    t.text     "detail"
    t.string   "exam"
    t.integer  "medical_case_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "states", :force => true do |t|
    t.string   "name",       :limit => 50, :null => false
    t.string   "code",       :limit => 3
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "states", ["name"], :name => "index_states_on_name", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",                           :null => false
    t.string   "encrypted_password",                    :default => "",                           :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                                      :null => false
    t.datetime "updated_at",                                                                      :null => false
    t.string   "firstname",               :limit => 40,                                           :null => false
    t.string   "lastname",                :limit => 40,                                           :null => false
    t.string   "username"
    t.integer  "medical_organization_id",                                                         :null => false
    t.string   "address1",                :limit => 50,                                           :null => false
    t.string   "address2",                :limit => 50
    t.string   "city",                    :limit => 50,                                           :null => false
    t.integer  "state_id"
    t.string   "zip",                     :limit => 10,                                           :null => false
    t.string   "phone",                   :limit => 50,                                           :null => false
    t.boolean  "active",                                :default => true
    t.integer  "role_id",                               :default => 0
    t.integer  "recent_session_time",                   :default => 0
    t.integer  "session_sign_in_count",                 :default => 0
    t.integer  "session_total_hours",                   :default => 0
    t.integer  "average_session_time",                  :default => 0
    t.boolean  "forem_admin",                           :default => false
    t.string   "forem_state",                           :default => "pending_review"
    t.boolean  "forem_auto_subscribe",                  :default => false
    t.string   "belt",                    :limit => 40, :default => "white"
    t.integer  "questions_count",                       :default => 0
    t.integer  "cases_count",                           :default => 0
    t.integer  "comments_count",                        :default => 0
    t.integer  "ratings_count"
    t.string   "time_zone",                             :default => "Pacific Time (US & Canada)"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
