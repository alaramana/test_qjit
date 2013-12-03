class Admin::ReportsController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_filter :authenticate_user!
  before_filter :convert_datetimepicker_dates, :only => [:user_submitted_cases]

  load_and_authorize_resource
  handles_sortable_columns
  def index
    @users = User.list(params[:page])

    # @sparing_mode = current_user.score_boards.where(:exam_mode=>"sparing_mode").group_by(&:exam_number).sort.reverse
    # @test_mode =current_user.score_boards.where(:exam_mode=>"exam_mode").group_by(&:exam_number).sort.reverse

    respond_to do |format|
      format.html
      format.js
    end
  end

  def user_submitted_cases
    require 'csv'
    @filters = OpenStruct.new(params[:search_filter])
    @sort =   OpenStruct.new(:col => sort_column, :dir=> sort_direction)
    @page =   OpenStruct.new(:page => params[:page], :per=>params[:per], :paginated=>params[:format].nil?) #CSV or XLS are not paginated
    @users   = Report.user_report(@filters,@sort,@page)

    respond_to do |format|
      format.html
      format.js
      format.csv
      format.xls
    end
  end

  def user_test
    @users = User.includes(:score_boards).list(params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def user_aggregate
    @users = User.list(params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def questions
    user = User.find(params[:user_id])
    params[:search] ={}
    params[:search][:status_contains] = "approved"
    params[:search][:created_at_gte]  = params[:from] if params[:from].present? and params[:from] != "undefined"
    params[:search][:created_at_lte]  = params[:to]   if params[:to].present? and params[:to] != "undefined"
    params[:search][:objective_id_in] = params[:obj]  if params[:obj].present? and params[:obj] != "undefined"    
    s=  user.exam_questions.search(params[:search])
    questions =  s.all.collect(&:question_prompt)
    render :json=> questions
  end

  #convert datetimepicker string parameters to Time objects (in views these are converted back into the appropriate string using display_time helper method
  def convert_datetimepicker_dates
    if params[:search_filter].present?
      params[:search_filter][:created_at_gte] = convert_datetime_pickerdate(params[:search_filter][:created_at_gte])
      params[:search_filter][:created_at_lte] = convert_datetime_pickerdate(params[:search_filter][:created_at_lte])
    end
  end

  def convert_datetime_pickerdate(chosen_date)
    Time.strptime(chosen_date,"%m/%d/%Y %H:%M %p %Z") unless chosen_date.nil? or chosen_date.empty?
  rescue ArgumentError # regular timestamp is MM/DD/YY HH:MM PP Z, but download as CSV sends the date as YY-MM-DD HH:MM:SS Z 
    Time.strptime(chosen_date,"%Y-%m-%d %H:%M:%S %Z") unless chosen_date.nil? or chosen_date.empty?
  end

  def org_assignments
    if params[:org].present?
      org         = MedicalOrganization.find(params[:org])    
      assignments = Objective.where_status_is_open_or_closed().where(:medical_organization_id=>org).order('name asc').collect {|p| [ p.name, p.id ] }
    else
      assignments = Objective.where_status_is_open_or_closed().order('name asc').collect {|p| [ p.name, p.id ] } 
    end
    render :json=> assignments
  end


  private

  #todo lock down options on sort columns and parameters
  def sort_column
    column = params[:qcol] || "lastname"
  end
  def sort_direction
    direction = params[:qdir] || "asc"
  end

end