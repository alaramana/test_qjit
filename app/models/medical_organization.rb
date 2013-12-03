# == Schema Information
#
# Table name: medical_organizations
#
#  id          :integer          not null, primary key
#  name        :string(75)       not null
#  status      :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  users_count :integer          default(0)
#

class MedicalOrganization < ActiveRecord::Base
  include RestrictDeletion
  extend RestrictDeletion::ClassMethods

  #Mass assignment
  attr_accessible :name

  #Strip white spaces
  normalize_attribute :name, :with => :strip

  #Associations
  has_many :users
  has_many :invites
  has_many :objectives
  #scopes
  default_scope order(:name)
  scope :where_active, -> {where("status"=>true)}
  

  validates :name, :presence   => true,
                   :uniqueness => {:case_sensitive => false}
                   # :length     => {:maximum => 50 }

  def creation_date
    created_at.try(:strftime, "%b %d, %Y")
  end

  def active_status
    status? ? "Active" : "Inactive"
  end

  def total_members
    users.count
  end

  def deactivate
    if self.users.count > 0
      msg = "Cannot deactivate '#{self.name}'. It has one or more members."
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

  def change_toggle_status
    new_status = !self.status
    new_status == true ? activate : deactivate
  end

  class << self
    def list(page_number)
      page(page_number)
    end
  end
end
