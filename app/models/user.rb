# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  email                   :string(255)      default(""), not null
#  encrypted_password      :string(255)      default(""), not null
#  reset_password_token    :string(255)
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0)
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :string(255)
#  last_sign_in_ip         :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  firstname               :string(40)       not null
#  lastname                :string(40)       not null
#  username                :string(255)
#  medical_organization_id :integer          not null
#  address1                :string(50)       not null
#  address2                :string(50)
#  city                    :string(50)       not null
#  state_id                :integer          not null
#  zip                     :string(10)       not null
#  phone                   :string(50)       not null
#  active                  :boolean          default(TRUE)
#  role_id                 :integer          default(0)
#  recent_session_time     :integer          default(0)
#  session_sign_in_count   :integer          default(0)
#  session_total_hours     :integer          default(0)
#  average_session_time    :integer          default(0)
#  forem_admin             :boolean          default(FALSE)
#  forem_state             :string(255)      default("pending_review")
#  forem_auto_subscribe    :boolean          default(FALSE)
#  belt                    :string(40)       default("white")
#  time_zone               :string           default("PDT")
#

class User < ActiveRecord::Base
  #Constants
  ROLES           = [nil, 'superadmin','admin', 'user']
  SUPERADMIN_ROLE = 1
  ADMIN_ROLE      = 2
  USER_ROLE       = 3

  include RestrictDeletion
  extend RestrictDeletion::ClassMethods
  include Devise
  rolify

  #Mass Assignments
  attr_accessible :email, :password, :password_confirmation,:firstname, :lastname,
  :city, :medical_organization_id, :active, :address1, :address2, :state_id,
  :zip,:phone, :role_id, :username, :belt, :forem_admin,  :questions_count, :ratings_count, :time_zone

  devise  :database_authenticatable, :registerable,:recoverable, :rememberable,
  :trackable, :validatable,:timeoutable,:token_authenticatable,:confirmable

  normalize_attribute :username, :email, :password, :password_confirmation,:firstname, :lastname,
  :city,  :address1, :address2, :zip,:phone,  :username, :with => :strip

  #Associations
  belongs_to :medical_organization, :counter_cache => true
  belongs_to :state
  belongs_to :role

  has_one    :member
  has_many   :invites, :foreign_key => :invitor_id

  has_many :medical_cases, :foreign_key => :creator_id

  has_many :exam_questions, :foreign_key => :creator_id

  has_many :favorites
  has_many :ratings
  has_many :score_boards
  has_many :comments, :foreign_key => :user_id

  #Validations
  validates :firstname, :presence => true,
  :format   => { :with => /^[A-z .'-]+$/,:allow_blank => true },
  :length   => { :maximum => 40,  :allow_blank => true   }

  validates :lastname,  :presence => true,
  # :format   => { :with => /^[A-z .'-]+$/, :allow_blank => true },
  :length   => { :maximum => 40,  :allow_blank => true   }

  # validates :username,   :presence   => true,
  # :uniqueness => {:case_sensitive => false },
  # :length     => { :maximum => 40, :minimum => 3,  :allow_blank => true }


  # validates :address1,   :presence => true,
  # :length   => { :maximum => 50, :allow_blank => true }

  # validates :address2,   :length  => { :maximum => 50, :allow_blank => true }

  # validates :city,        :presence => true,
  # :length   => { :maximum => 50, :allow_blank => true }

  # validates :state_id,    :presence => true
  validates :zip,
  :format   => { :with  => /\b[0-9]{5}(?:-[0-9]{4})?\b/, :allow_blank => true },
  #:numericality => { :only_integer => true },
  :length       => { :minimum => 5,:maximum => 10, :allow_blank => true }

  validates :phone,:allow_blank => true,
  :format   => /^([0-9\(\)\/\+ \-+\s]*)$/,
  :length   => { :maximum => 20, :minimum => 10, :allow_blank => true }

  validates :role_id,     :uniqueness => { :if => :superadmin? }

  validates :password,   :presence => {:on => :create}, :confirmation => {:allow_blank => true},
  :length => {:in => 8..50, :allow_blank => true }

  validates :email,      :presence   => true,
  :uniqueness => {:case_sensitive => false},
  :length     => {:maximum => 150, :allow_blank => true},
  :format     => {
    :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/,
    :allow_blank => true
  }

  validates :time_zone, :presence=>true


  #Callbacks
  before_create :set_user_role
  after_create :update_invitation_status,:confirmation_required?
  # before_update :unique_email# custom



  # def unique_email    
  #   if Invite.find_by_email_and_status(self.email,false)
  #     self.errors.add(:email, "Email is already in use by another user")
  #     return false
  #   end
  # end

  #Scopes
  # default_scope order(:firstname)

  def confirmation_required?
    false
  end

  #Instance methods
  def full_name
    [firstname, lastname].join(" ")
  end

  def joined_date
    created_at
  end

  def role_name
    User::ROLES[self.role_id]
  end

  def superadmin?
    role_id == User::SUPERADMIN_ROLE
  end

  def admin?
    role_id == User::ADMIN_ROLE
  end

  def invite_user(user_email, user_role_id,school_id)
    if superadmin? or admin?
      invitation = self.invites.new(:email => user_email, :role_id => user_role_id, :medical_organization_id=>school_id)
    end
  end

  def to_s
    self.full_name
  end


  class << self
    def list(page_number)
      page(page_number)
    end
  end


  #Private methods
  private
  def set_user_role
    self.belt="white"
    invitation   = Invite.find_by_email(self.email)
    unless superadmin? or invitation.expired?
      self.role_id =  invitation.role_id
      self.forem_admin = true if invitation.role_id == 2
      self.medical_organization_id = invitation.medical_organization_id
    end
  end

  def update_invitation_status

    unless superadmin?
      invite = Invite.find_by_email(self.email)
      invite.update_attribute("status",true)
    end
  end

end
