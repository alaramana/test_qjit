# == Schema Information
#
# Table name: medical_cases
#
#  id                         :integer          not null, primary key
#  title                      :string(255)
#  age                        :integer
#  gender                     :string(255)
#  race_id                    :integer
#  chief_complaint            :text
#  history_of_present_illness :text
#  creator_id                 :integer
#  status                     :string(255)
#  educational_objective      :text
#  average_rating             :decimal(, )      default(0.0), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

class MedicalCase < ActiveRecord::Base

  attr_accessible :age, :average_rating, :chief_complaint, :creator_id, :educational_objective, :gender, :history_of_present_illness, :race, :status, :title, :medical_history_attributes,  :review_attributes, :labs_attributes, :imagings_attributes, :other_studies_attributes, :question_attributes, :tag_list,:race_id


  acts_as_commentable
  acts_as_taggable
  belongs_to :user, :foreign_key => :creator_id
  has_one :review
  has_one :medical_history
  has_one :question

  has_many :labs
  has_many :imagings
  has_many :other_studies
  has_many :score_boards
  belongs_to :race

  has_many :favorites
  has_many :ratings, :extend=>RatingsExtension
  belongs_to :user, :foreign_key => :creator_id

  accepts_nested_attributes_for :review, :allow_destroy => true#, :reject_if => lambda { |a| a[:traffic_id].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :medical_history, :allow_destroy => true
  accepts_nested_attributes_for :labs, :allow_destroy => true
  accepts_nested_attributes_for :imagings, :allow_destroy => true
  accepts_nested_attributes_for :other_studies, :allow_destroy => true
  accepts_nested_attributes_for :question

  validates :title,      :presence   => true,
  :uniqueness => {:case_sensitive => false}

  validates :age, :presence => true, :numericality => {:only_integer => true,  :greater_than => 0, :less_than_or_equal_to => 150 }


  state_machine :status, :initial => :pending do
    event :draft do
      transition all => :draft
    end
    event :inactive do
      transition all => :inactive
    end
    event :approved do
      transition all => :approved
    end
    event :pending do
      transition all => :pending
    end
  end


  def self.all_models
    includes(:ratings, :user, :favorites, :score_boards)
  end

  def check_status(status)
    if status=="draft"
      self.update_column(:status, "draft")
      return true
    else
      self.update_column(:status, "pending")
      return false
    end
  end


  class << self
    def list(current_user, params)
      options        = {:page => params[:page], :query => params[:search], :order => params[:order],
      :not_answer => params[:not_answer], :tag_name=>params[:tag_name] }
      page_number, query, sort, tag_name = options[:page], options[:query], options[:order], options[:tag_name]
      @current_user = current_user
      page_number = page_number || 1      
      qcount = 0
      @arel = self.includes(:comments, :tags, :favorites, :ratings, :user)
      @arel = @arel.where("medical_cases.status" => 'approved')   if current_user.role_id == 3 # Normal user
      @arel = @arel.where("medical_cases.status not in ('draft')") if [1,2].include?(current_user.role_id) # Admin and superadmin


      if query.present?
        self.search_by_title(query["title_contains"])
        self.search_by_average_rating(query["average_rating_greater_than"])
        self.search_by_author(query["user_firstname_contains"])
        self.search_by_myratings(query["ratings_rate_greater_than"])

        self.search_by_tags(tag_name)
        if query["favorites_is_active_is_true"].present?
          self.search_by_myfavorites
        end
      end

      self.search_by_answer_type(query, options[:not_answer])

      if options[:not_answer].present? and query['score_boards_correct_is_true'].blank? and query['score_boards_correct_is_false'].blank?
        self.search_by_unanswered
      end            

      # sorting
      case sort
      when "created_at" then
        @arel = @arel.order("medical_cases.created_at DESC, medical_cases.title ASC")
      when "author" then
        @arel = @arel.order("users.firstname DESC, medical_cases.title ASC")
      when "personal"  then
        rated     = @arel.where('ratings.user_id=?', current_user.id).order('ratings.rate DESC')
        rated_ids = rated.collect(&:id)
        not_rated = @arel.where("medical_cases.id NOT IN(?)", rated_ids).order('medical_cases.title ASC')
        @arel = Kaminari.paginate_array(rated + not_rated)
      when "average"
        @arel = @arel.order("medical_cases.average_rating DESC, medical_cases.title ASC")
      else
        @arel = @arel.order("medical_cases.average_rating DESC, medical_cases.title ASC")
      end      
      return @arel.page(page_number)
    end

    def search_by_myfavorites
      @arel = @arel.joins(:favorites).where("favorites.user_id" => @current_user.id)
    end

    def search_by_title(title)
      if title.present?
        @arel = @arel.where("LOWER(medical_cases.title) LIKE ?", "%#{title.downcase.strip}%")
        # raise @arel.inspect
      end
      @arel
    end

    def search_by_average_rating(rating)
      if rating.present?
        @arel = @arel.where("average_rating > ?", rating.to_i)
      end
      @arel
    end


    def search_by_myratings(rating)
      if rating.present?
        @arel = @arel.where("ratings.rate > ?", rating.to_i)
      end
      @arel
    end


    def search_by_author(author)
      if author.present?
        va = author.downcase
        @arel = @arel.joins(:user).where("LOWER(CONCAT(firstname,' ',lastname)) LIKE ?", "%#{va}%")
      end
      @arel
    end

    def search_by_answer_type(query, not_answer)

      return @arel if query.blank? and not_answer.nil?

      if (query['score_boards_correct_is_true'].blank? and query['score_boards_correct_is_false'].blank?) and
        not_answer.present?
        return @arel
      end
      type = []
      type << "t" if query['score_boards_correct_is_true'].present?
      type << "f" if query['score_boards_correct_is_false'].present?

      if not_answer.present?
        if type.present?
          @arel = @arel.where("medical_cases.id NOT IN (SELECT score_boards.medical_case_id
          FROM score_boards where user_id = #{@current_user.id})
          OR medical_cases.id IN (SELECT score_boards.medical_case_id
          FROM score_boards where user_id = #{@current_user.id}
          AND score_boards.correct IN (?))", type
          )

          @arel
        end
      elsif type.present?
        @arel = @arel.joins(:score_boards).where("score_boards.user_id" => @current_user.id,"score_boards.correct" => type)
      end

    end

    def search_by_unanswered
      @arel = @arel.where("medical_cases.id NOT IN
      (SELECT score_boards.medical_case_id FROM score_boards where user_id = ?)",
      @current_user.id)
    end

    def search_by_tags(tag)      
      if tag.present?        
        @arel = @arel.where(:status =>"approved").tagged_with(tag.split(','), :any => true)  
      end
      @arel      
    end



    def approved_cases(params)
      @medical_case_status = MedicalCase.find(params[:id])
      @medical_case_status.approved!
      user = User.find(@medical_case_status.creator_id)
      if !user.nil?
        mcount = user.medical_cases.where(:status=>"approved").count
        user.update_column(:cases_count, mcount)
      end
    end

    def auto_complete_author(name)
      users = User.select([:firstname, :lastname]).where("LOWER(CONCAT(firstname,' ',lastname)) LIKE ?", "%#{name.downcase}%")
      result = users.collect do |t|
        name =  t.firstname.downcase + " " + t.lastname.downcase
        { value: name }
      end
      result << {value: "hidden"}
    end

    def auto_complete_tag(name)
      users =  MedicalCase.where(:status=>"approved").tag_counts.select([:name]).where("name LIKE ?", "%#{name.downcase}%")
      result = users.collect do |t|
        { value: t.name.downcase }
      end
    end
  end  

end
