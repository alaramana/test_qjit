# == Schema Information
#
# Table name: exam_questions
#
#  id                         :integer          not null, primary key
#  question_prompt            :text
#  objective_id               :integer
#  creator_id                 :integer
#  educational_purpose        :text
#  medical_case_id            :integer
#  correct_answer             :string(255)
#  correct_answer_explanation :string(255)
#  incorrect_1                :string(255)
#  incorrect_1_explanation    :string(255)
#  status                     :string(255)      default("approved")
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  average_rating             :decimal(, )      default(0.0), not null
#  photo_file_name            :string(255)
#  photo_content_type         :string(255)
#  photo_file_size            :integer
#  photo_updated_at           :datetime
#

class ExamQuestion < ActiveRecord::Base
  attr_accessible :photo, :creator_id, :objective_id, :question_prompt, :educational_purpose, :medical_case_id,   :correct_answer, :correct_answer_explanation,
  :incorrect_1, :incorrect_1_explanation, :incorrect_answers_attributes , :status, :tag_list,:average_rating, :position
  acts_as_taggable

  serialize :position #storing position as array

  acts_as_commentable
  belongs_to :objective
  belongs_to :medical_case
  belongs_to :user, :foreign_key => :creator_id
  has_many :incorrect_answers
  has_many :favorites
  has_many :ratings, :extend => RatingsExtension
  has_many :score_boards

  accepts_nested_attributes_for :incorrect_answers, :reject_if => lambda { |a| a[:answer].blank? }, :allow_destroy => true

  before_save :set_position

  validates :question_prompt,:presence   => true, :uniqueness => {:case_sensitive => false}

  has_attached_file :photo, :styles => { :small => "150x150>" },
  :url  => "/assets/exam_questions/:id/:style/:basename.:extension",
  :path => "#{::Rails.root.to_s}/public/assets/exam_questions/:id/:style/:basename.:extension"

  validates_attachment   :photo,
  :content_type => { :content_type => /image/, :message=>"is invalid" },
  :size => { :in => 0..10000.kilobytes, :message=>"it should be less then 10MB" }

  validate :check_image_type

  def check_image_type
    self.errors.delete(:photo)
  end

  def set_position
    self.position =[0,1,2,3,4].sample(5)
  end

  def build_answer
    3.times do
      self.incorrect_answers.build
    end
  end

  def change_status(current_user)
    qcout = current_user.exam_questions.where(:status=>"approved").count
    current_user.update_column(:questions_count, qcout)
  end

  def update_status(current_user)
    self.update_column(:status, "approved")
    qcout = current_user.exam_questions.where(:status=>"approved").count
    current_user.update_column(:questions_count, qcout)
  end



  class << self
    def list(current_user, options= {})
      page_number, query, sort, tag_name, step = options[:page], options[:query], options[:order], options[:tag_name], options[:step]
      @current_user = current_user
      page_number = page_number || 1      
      qcount = 0

      @arel = self.includes(:ratings, :comments, :tags, :user, :favorites, :score_boards, :objective)

      @arel = @arel.where("exam_questions.status" => 'approved')   if current_user.role_id == 3 # Normal user
      @arel = @arel.where("exam_questions.status not in ('draft')") if [1,2].include?(current_user.role_id) # Admin and superadmin      
    
      objectives   = Objective.where_status_is_open_or_closed().collect {|p| [ p.name, p.id ] }


      if query.present?
        self.search_by_title(query["question_prompt_contains"])
        self.search_by_average_rating(query["average_rating_greater_than"], query)
        self.search_by_author(query["user_firstname_contains"],query)
        self.search_by_objective(query["objective_name_contains"])
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

      # Sorting
      case sort
      when "created_at" then
          @arel = @arel.order("exam_questions.created_at DESC, exam_questions.question_prompt ASC")
      when "author" then
         @arel = @arel.order("users.firstname DESC, exam_questions.question_prompt ASC")
      when "personal" 
        rated     = @arel.where('ratings.user_id=?', current_user.id).order('ratings.rate DESC')
        not_rated = @arel.where("exam_questions.id NOT IN(?)", rated.collect(&:id)).order('exam_questions.question_prompt ASC')
        @arel     = Kaminari.paginate_array(rated + not_rated)        
      when "review"
        @arel = @arel.order("exam_questions.total_ratings ASC, exam_questions.question_prompt ASC")
      end 

      todayDate =Time.now
      question_count = @arel.size
      
      if sort.nil? or sort =="average"
        without_hide  = @arel.where("(objectives.situation = ? OR objectives.hide_feedback=?) OR exam_questions.objective_id is NULL", todayDate, false).order("exam_questions.average_rating DESC, exam_questions.question_prompt ASC")
        with_hide   = @arel.where("((objectives.start_date <= ? AND objectives.end_date >= ?) AND objectives.hide_feedback=?)", todayDate, todayDate, true).order("exam_questions.question_prompt ASC")

        @arel =   without_hide | with_hide
        question_count = @arel.size
        @arel = Kaminari.paginate_array(@arel)
      end

      return @arel.page(page_number), question_count, objectives, @arel.page(step).per(1)
    end


    def search_by_myfavorites
      @arel = @arel.joins(:favorites).where("favorites.user_id" => @current_user.id)
    end

    def search_by_title(title)
      if title.present?
        @arel = @arel.where("LOWER(exam_questions.question_prompt) LIKE ?", "%#{title.downcase.strip}%")
      end
      @arel
    end

    def search_by_average_rating(rating, query)
      todayDate =Time.now
      if rating.present?
        if rating =="hidden"
          @arel = @arel.where("((objectives.start_date <= ? AND objectives.end_date >= ?) AND objectives.hide_feedback=?)", todayDate, todayDate, true)
        else
          @arel = @arel.where("(objectives.end_date < ? OR objectives.hide_feedback=?) OR exam_questions.objective_id is NULL", todayDate, false)
          @arel = @arel.where("average_rating > ?", rating.to_i)
        end
      end
      @arel
    end

    def search_by_myratings(rating)
      if rating.present?
        @arel = @arel.where("ratings.rate > ?", rating.to_i)
      end
      @arel
    end

    def search_by_author(author, query)
      todayDate =Time.now
      if author.present?
        if author =="hidden"
          @arel = @arel.where("((objectives.start_date <= ? AND objectives.end_date >= ?) AND objectives.hide_author=?)", todayDate, todayDate, true)
        else
          @arel = @arel.where("(objectives.end_date < ? OR objectives.hide_author=?) OR exam_questions.objective_id is NULL", todayDate, false)
          va = author.downcase
          @arel = @arel.joins(:user).where("LOWER(CONCAT(firstname,' ',lastname)) LIKE ?", "%#{va}%")
        end
      end
    end    

    def search_by_objective(objective)
      if objective.present?
        @arel = @arel.where("objectives.id = ?", objective)
      end
      @arel
    end
    
    def search_by_tags(tag)
      if tag.present?
        @arel = @arel.tagged_with(tag.split(','), :any => true)
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
          @arel = @arel.where("exam_questions.id NOT IN (SELECT score_boards.exam_question_id
          FROM score_boards where user_id = #{@current_user.id})
          OR exam_questions.id IN (SELECT score_boards.exam_question_id
          FROM score_boards where user_id = #{@current_user.id}
          AND score_boards.correct IN (?))", type
          )

          @arel
        end
      elsif type.present?
        @arel = @arel.joins(:score_boards).where("score_boards.user_id" => @current_user.id,"score_boards.correct" => type)
      end
      @arel
    end


    def search_by_unanswered
      @arel = @arel.where("exam_questions.id NOT IN
      (SELECT score_boards.exam_question_id FROM score_boards where user_id = ?)",
      @current_user.id)
    end


    def auto_complete_tag(name)
      users =  ExamQuestion.tag_counts.select([:name]).where("LOWER(name) LIKE ?", "%#{name.downcase}%")
      result = users.collect do |t|
        { value: t.name.downcase }
      end
    end

    def exam_question_mode(current_user)
      overview       = current_user.score_boards.where(:exam_mode=>"exam_mode")
      overview.update_all(:status=>"completed")
      exam_mode      = overview.group_by(&:exam_number).sort.last
      total_corrects = exam_mode[1].collect{|i| i.correct if i.correct==true}.compact.size
      total_time     = exam_mode[1].collect{|i| i.time_taken.to_i}.sum
      return overview,exam_mode,total_corrects,total_time
    end

    def not_exam_mode(current_user)
      overview       = current_user.score_boards.where(:exam_mode=>"sparring_mode")
      overview.update_all(:status=>"completed")
      if overview.present?
        sparring_mode  =  overview.group_by(&:exam_number).sort.last
        total_corrects =  sparring_mode[1].collect{|i| i.correct if i.correct==true}.compact.size
        total_time     =  sparring_mode[1].collect{|i| i.time_taken.to_i}.sum
        mode = true
      else
        mode = false
      end
      return overview, sparring_mode, total_corrects, total_time, mode
    end


  end

  def self.sparring(current_user, options={})
    page_number, question =   options[:step], options[:question]
    page_number           = page_number || 1

    @arel           = self.list(current_user, options)
    @list           = @arel.last

    exam_question   = ExamQuestion.find(question) if question.present?
    exam_question   = @list.first                 if !question.present?

    unless exam_question.nil?
      medical_case    = MedicalCase.find(exam_question.medical_case_id) unless exam_question.medical_case_id.nil?

      question_choice = exam_question.incorrect_answers.collect(&:answer)
      question_choice = question_choice << exam_question.correct_answer
      question_choice = question_choice << exam_question.incorrect_1

      explanations = exam_question.incorrect_answers.collect(&:explanation)
      explanations    = explanations << exam_question.correct_answer_explanation
      explanations    = explanations << exam_question.incorrect_1_explanation
      is_done         = current_user.score_boards.where(:status=>"incomplete", :exam_mode=>"sparring_mode")
      result          = current_user.score_boards.find_all_by_exam_mode_and_exam_question_id_and_status('sparring_mode', exam_question.id, "incomplete").last
      overview        = current_user.score_boards.where(:exam_mode=>'sparring_mode', :exam_question_id=>exam_question.id).order('created_at DESC')

      return @list, medical_case, exam_question, question_choice, is_done, result, overview, explanations
    end
  end

  def self.exam(current_user, options={})
    page_number, question   =  options[:page], options[:question]
    page_number     = page_number || 1
    @arel           = self.list(current_user, options)
    @list           = @arel.last
    qcount          = @arel[1]

    exam_question   = ExamQuestion.find(question) if question.present?
    exam_question   = @list.first                 if !question.present?

    medical_case    = MedicalCase.find(exam_question.medical_case_id) unless exam_question.medical_case_id.nil?

    question_choice = exam_question.incorrect_answers.collect(&:answer)
    question_choice = question_choice << exam_question.correct_answer
    question_choice = question_choice << exam_question.incorrect_1

    explanations    = exam_question.incorrect_answers.collect(&:explanation)
    explanations    = explanations << exam_question.correct_answer_explanation
    explanations    = explanations << exam_question.incorrect_1_explanation

    is_done         = current_user.score_boards.where(:status=>"incomplete", :exam_mode=>"exam_mode")
    result          = current_user.score_boards.find_all_by_exam_mode_and_exam_question_id_and_status('exam_mode', exam_question.id, "incomplete").last
    score           = current_user.score_boards.where(:exam_mode=>"exam_mode", :status=>"incomplete", :correct=>true).size
    overview        = current_user.score_boards.where(:exam_mode=>'exam_mode', :exam_question_id=>exam_question.id).order('created_at DESC')

    return @list, medical_case, exam_question, question_choice, is_done, result, score,qcount, overview, explanations
  end
 
end

