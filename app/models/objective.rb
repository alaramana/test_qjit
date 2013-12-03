# == Schema Information
#
# Table name: objectives
#
#  id         :integer          not null, primary key
#  name       :string(75)       not null
#  suspended  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  start_date :datetime
#  end_date   :datetime

#  status is a string defined on load
#

class Objective < ActiveRecord::Base
  attr_accessible :name, :start_date, :end_date, :suspended, :hide_author, :hide_feedback, :description, :medical_organization_id
  attr_accessor :status
  has_many :exam_questions
  belongs_to :medical_organization

  validates :name,  :presence   => true,
  :uniqueness => {:case_sensitive => false},
  :length     => {:maximum => 50 }
  
  validates :medical_organization_id,  :presence   => true

  validates :start_date,  :presence =>  true,
  :date =>  {:after_or_equal_to => Time.now.in_time_zone},
  :if => :start_date_changed?

  validates :end_date,   :allow_nil  => true,
  :date=> {:after =>:start_date}

  # default_scope order(:name)


  def start_date_changed?
    self.start_date_was!=self.start_date
  end



  # Queries for scoping objectives based on status
  scope :where_status_is_suspended, ->       { where("suspended=true").order('name asc') }
  scope :where_status_is_not_suspended, ->   { where("suspended=false").order('name asc') }
  scope :where_status_is_pending, ->         { where("suspended=false AND start_date > :today",{:today=>Time.now}).order('name asc') }
  scope :where_status_is_open, ->            { where("suspended=false AND start_date <= :today AND (end_date is null OR end_date >= :today)",{:today=>DateTime.now}).order('name asc') }
  scope :where_status_is_open_or_closed, ->  { where("suspended=false AND start_date <= :today",{:today=>Time.now}).order('name asc') }


  after_find do |objective|
    today = Time.now
    if(objective.suspended?)
      objective.status = "Suspended"
    elsif(!objective.start_date.nil? && objective.start_date > today)
      objective.status = "Pending"
    elsif(!objective.end_date.nil? && objective.end_date < today)
      objective.status = "Closed"
    else
      objective.status = "Open"
    end
    objective.situation = objective.status
    objective.save if objective.situation != objective.status
  end

  def change_toggle_status
    self.suspended? ? activate : suspend
  end

  def suspend
    if self.exam_questions.count > 0
      msg = "Cannot deactivate '#{self.name}'. It has one or more exam questions."
      errors.add(:base, msg)
      return false
    else
      self.suspended = true
      self.save
    end
  end

  def activate
    self.suspended = false
    self.save
  end

  class << self
    def list(page_number)
      page(page_number)
    end
  end
end
