class UpdateRatingsCountToUsers < ActiveRecord::Migration
  def up
  	User.all.each do |user|
      rate_count = user.ratings.size
      user.update_attributes(:ratings_count=>rate_count)
    end
  end

  def down
  end
end
