# This migration comes from forem (originally 20120227202639)
class RemovePendingReviewFromForemTopicsAddState < ActiveRecord::Migration
  def up
    remove_column :forem_topics, :pending_review
    add_column :forem_topics, :state, :string, :default => 'pending_review'
    add_index :forem_topics, :state
  end

  def down
    add_column :forem_topics, :pending_review, :boolean, :default => true
    remove_index :forem_topics, :state
    remove_column :forem_topics, :state
  end
end
