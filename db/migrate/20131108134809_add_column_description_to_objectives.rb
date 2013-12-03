class AddColumnDescriptionToObjectives < ActiveRecord::Migration
  def change
    add_column :objectives, :description, :text
  end
end
