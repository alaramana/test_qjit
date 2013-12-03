# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  name       :string(50)       not null
#  code       :string(3)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class State < ActiveRecord::Base
  attr_accessible :name, :code
  has_many :users
end
