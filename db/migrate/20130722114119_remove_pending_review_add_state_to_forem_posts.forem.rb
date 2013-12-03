# This migration comes from forem (originally 20120227195911)
class RemovePendingReviewAddStateToForemPosts < ActiveRecord::Migration
  def up
    remove_column :forem_posts, :pending_review
    add_column :forem_posts, :state, :string, :default => 'pending_review'
    add_index :forem_posts, :state
  end

  def down
    add_column :forem_posts, :pending_review, :boolean, :default => true
    remove_index  :forem_posts, :state
    remove_column :forem_posts, :state
  end

end
