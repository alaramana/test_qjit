# == Schema Information
#
# Table name: invites
#
#  id                      :integer          not null, primary key
#  email                   :string(255)      default(""), not null
#  role_id                 :integer
#  invitation_token        :string(255)
#  status                  :boolean          default(FALSE)
#  invitor_id              :integer
#  medical_organization_id :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Invite < ActiveRecord::Base
  #  include RestrictDeletion
  #extend RestrictDeletion::ClassMethods

  #Mass assignment
	attr_accessible :email, :role_id, :medical_organization_id

  #Normalization
  normalize_attribute :email, :role_id, :with => :strip

  #Associations
	belongs_to :user, :foreign_key => :invitor_id
  belongs_to :role
  belongs_to :medical_organization, :foreign_key => :medical_organization_id

  #Validations
  validates :email, :presence   => true,
                    :uniqueness => {:case_sensitive => false, :allow_blank => true},
                    :length     => {:maximum => 150, :allow_blank => true},
                    :format     => {
                        :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i,
                        :allow_blank => true
                    }
  validates :invitor_id,       :presence => true
  validates :medical_organization_id, :presence => true
	validates :role_id,					 :presence => true
  # validates :invitation_token, :presence => true


  validate :email_uniqueness # custom

  def email_uniqueness
    if User.find_by_email(self.email)
      self.errors.add(:email, "is already in use by another user")  if  self.errors.blank?
    end
  end

  before_save {|invite| invite.email=invite.email.downcase}

  after_create :set_invitation_token
  before_validation :set_role_id

  def send_mail(sender)
    # update_column(:invitor_id, sender.id)
    UserMailer.send_user_invitation(self,sender).deliver
  end

  def set_invitation_token
    self.invitation_token = SecureRandom.urlsafe_base64
    self.save
  end

	def set_role_id
		self.role_id =  User::USER_ROLE unless role_id.present?
  end

  #set expiry as 5 days
  def expired?
    (Time.now.utc - self.updated_at) > 5.days
  end

  class << self
    def list(page_number)
      page(page_number)
    end
  end

end