class ExamQuestionsController < ApplicationController
  include MedicalCasesHelper
  include BeltExtension
  before_filter :authenticate_user!
  layout  "medical_cases"

  def index
    options        = {:page => params[:page], :query => params[:search], :order => params[:order],
    :not_answer => params[:not_answer], :tag_name=>params[:tag_name] }
    question       = ExamQuestion.list(current_user, options)       
    @exam_questions, @qcount, @objectives  = question    
 
    # for exams question
    @search, @filters, @medical_case, @exam_question = return_objects(params) #application controller    
    @exam_question.build_answer
  end

  def new
    @exam_question      = ExamQuestion.new
    @medical_cases      = MedicalCase.where(:status=>"approved")
    @opened_assignments = Objective.where_status_is_open().where(:medical_organization_id=>current_user.medical_organization).order('name asc').collect {|p| [ p.name, p.id ] } 
    @exam_question.build_answer
    render :layout => false
  end

  def edit
    @exam_question      = ExamQuestion.find(params[:id])
    @opened_assignments = Objective.where_status_is_open().where(:medical_organization_id=>current_user.medical_organization).order('name asc').collect {|p| [ p.name, p.id ] } 
    @medical_cases      = MedicalCase.where(:status=>"approved")
    if !@exam_question.incorrect_answers.present?
      @exam_question.build_answer
    end
    render :layout => false
  end

  def create
    filters = eval(params[:search])

    @exam_question = ExamQuestion.new(params[:exam_question])
    @exam_question.creator_id = current_user.id
    if @exam_question.save
      if @exam_question.change_status(current_user)
        redirect_to exam_questions_path(:params=>filters), :notice => "Exam question  was  created successfully."
      end
      update_belt
    else
      redirect_to exam_questions_path(:params=>filters), :alert => "#{@exam_question.errors.full_messages.to_sentence}, please try again"
    end
  end

  def ratings
    @user_rate =    current_user.ratings.find_by_exam_question_id(params[:idBox])
    if @user_rate.nil?
      Rating.create(:exam_question_id=>params[:idBox], :user_id=>current_user.id, :rate=>params[:rate])
      user = User.find(current_user.id)
      user.update_column(:ratings_count, user.ratings.count)
    else
      @user_rate.update_column(:rate, params[:rate])
    end
    Rating.calculate_question_average
    render :json => @user_rate
  end

  def add
    @favorite = Favorite.create(:user_id=>current_user.id, :exam_question_id=> params[:id], :is_active=>true)
    render  :json => @favorite
  end

  def remove
    @favorite = Favorite.find_by_user_id_and_exam_question_id(current_user.id, params[:id])
    @favorite.destroy
    render :json => @favorite
  end

  def autocomplete_tag_name
    result = ExamQuestion.auto_complete_tag(params[:name])
    render json: result
  end

  def overview
    if params[:exam]=="exam_mode"
      @overview, @exam_mode, @total_corrects, @total_time = ExamQuestion.exam_question_mode(current_user)
    else
      @overview, @sparring_mode,@total_corrects,@total_time, overview = ExamQuestion.not_exam_mode(current_user)
      unless @overview.present?
        redirect_to  exam_questions_path(params)
      end
    end
  end


  def sparring_mode
    @filters  = {:search=>params[:search], :tag_name=>params[:tag_name], :not_answer => params[:not_answer], :order=>params[:order]}
    options   = {:step => params[:page], :mcase=>params[:id], :question=>params[:question], :query => params[:search], :order => params[:order],
    :not_answer => params[:not_answer], :tag_name=>params[:tag_name]}
    question  = ExamQuestion.sparring(current_user, options)
    redirect_to overview_exam_questions_path(:exam=>"sparring_mode",:params=>@filters) if question.nil?
    @nexts, @medical_case, @exam_question, @no_of_choice, @is_done, @score, @overview, @explanations = question  
  end

  def exam_mode
    @filters  = {:search=>params[:search], :tag_name=>params[:tag_name], :not_answer => params[:not_answer], :order=>params[:order]}
    options   = {:step => params[:page], :mcase=>params[:id], :question=>params[:question], :query => params[:search], :order => params[:order],
    :not_answer => params[:not_answer], :tag_name=>params[:tag_name]}
    question  = ExamQuestion.exam(current_user, options)
    @nexts,  @medical_case, @exam_question, @no_of_choice,@is_done,@score, @taken_score, @qcount, @overview, @explanations= question
  end

  def update
    @exam_question = ExamQuestion.find(params[:id])
    if @exam_question.update_attributes(params[:exam_question])
      # if params[:status]=="draft"
      #   @exam_question.update_column(:status, "draft")
      #   redirect_to exam_questions_path, :notice => "Your question is saved as a draft. In order to edit your question or submit your question to the community, please go to  <a href='#{url_for(myprofile_exam_questions_path)}'>My Profile</a>"
      # else
      @exam_question.update_status(current_user)
      redirect_to exam_questions_path, :notice => "Exam question  was  updated successfully."
      # end
    else
      redirect_to exam_questions_path, :alert => "#{@exam_question.errors.full_messages.to_sentence}, please try again"
    end
  end

  def get_comments
    @question = ExamQuestion.find(params[:id])
    render :layout=> false
  end 

  def get_tags
    @question = ExamQuestion.find(params[:id])
    render :layout=> false
  end

end
