# == Schema Information
#
# Table name: races
#
#  id         :integer          not null, primary key
#  name       :string(75)       not null
#  status     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Race < ActiveRecord::Base
  attr_accessible :name
  has_many :medical_cases


  validates :name,  :presence   => true,
                    :uniqueness => {:case_sensitive => false}
                    # :length     => {:maximum => 50 }
                    # :format   => { :with => /^[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_][a-zA-Z0-9-]*$/,:allow_blank => true }


  def change_toggle_status
    new_status = !self.status
    new_status == true ? activate : deactivate
  end

  def deactivate
    if self.medical_cases.count > 0
      msg = "Cannot deactivate '#{self.name}'. It has one or more medical cases."
      errors.add(:base, msg)
      return false
    else
      self.status = false
      self.save
    end
  end

  def activate
    self.status = true
    self.save
  end

  def to_s
    name
  end

  class << self
    def list(page_number)
      page(page_number)
    end
  end

end
