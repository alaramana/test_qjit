class AddSituationToObjectives < ActiveRecord::Migration
  def change
    add_column :objectives, :situation, :string
  end
end
