# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  title            :string(50)       default("")
#  comment          :text
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  role             :string(255)      default("comments")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment
  attr_accessible :comment, :title

  belongs_to :commentable, :polymorphic => true

  default_scope -> { order('created_at DESC') }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable
  validates_presence_of :comment

  # NOTE: Comments belong to a user
  belongs_to :user, :foreign_key => :user_id

  # def self.call(search = nil)
  #   Rails.cache.fetch("all_cmts_#{search}", :expires_in => 1.day) do
  #     self.where("title like ?","%#{search}%").all
  #   end
  # end

  # def add_user(user)
  #   self.user_id = user.id
  # end
end
