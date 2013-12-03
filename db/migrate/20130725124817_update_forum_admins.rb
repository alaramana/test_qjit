class UpdateForumAdmins < ActiveRecord::Migration
  def up
    User.where(:role_id => [1,2]).update_all(:forem_admin => true)
  end

  def down
    User.where(:role_id => [1,2]).update_all(:forem_admin => nil)
  end
end
