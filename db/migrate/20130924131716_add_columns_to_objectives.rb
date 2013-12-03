class AddColumnsToObjectives < ActiveRecord::Migration
  def change
    add_column :objectives, :hide_author, :boolean, :default=> false
    add_column :objectives, :hide_feedback, :boolean, :default=> false
  end
end
