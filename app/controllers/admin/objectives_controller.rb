class Admin::ObjectivesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :convert_datetimepicker_dates, :only => [:create, :update]
  before_filter :organizations

  load_and_authorize_resource
  handles_sortable_columns

  def index
    order         = sortable_column_order
    @filters      = OpenStruct.new(params[:search])
    objective     = Objective.includes(:exam_questions)
    if @filters.status_is_true =="suspended"
      @objectives  = objective.where_status_is_suspended.list(params[:page]).order(:created_at) if !order
      @objectives  = objective.where_status_is_suspended.list(params[:page]).order(order) if order
    elsif @filters.status_is_true =="active"
      @objectives  = objective.where_status_is_not_suspended.list(params[:page]).order(:created_at) if !order
      @objectives  = objective.where_status_is_not_suspended.list(params[:page]).order(order) if order
    else
      @objectives  = objective.list(params[:page]).order(:created_at) if !order
      @objectives  = objective.list(params[:page]).order(order) if order
    end
  end

  def new
    @objective = Objective.new
  end

  def edit
    @objective = Objective.find(params[:id])    
  end

  def create
    @objective = Objective.new(params[:objective])

    if @objective.save
      redirect_to admin_objectives_path, notice: 'Assignment was successfully created.'
    else
      render :action =>"new"
    end
  end

  def update
    @objective = Objective.find(params[:id])
    if @objective.update_attributes(params[:objective])
      redirect_to admin_objectives_path, notice: 'Assignment was successfully updated.'
    else
      render action: "edit"
    end
  end

  def toggle_status
    @objective = Objective.find(params[:id])
    name       = @objective.name
    if @objective.change_toggle_status
      msg = @objective.suspended? ? "#{name} is suspended." : "#{name} is activated."
      redirect_to admin_objectives_path, notice: msg
    else
      msg = @objective.errors.full_messages.to_sentence
      redirect_to admin_objectives_path, alert: msg
    end
  end

  #convert datetimepicker string parameters to Time objects (in views these are converted back into the appropriate string using display_time helper method
  def convert_datetimepicker_dates    
    if params[:objective].present?
      params[:objective][:start_date] = convert_datetime_pickerdate(params[:objective][:start_date])
      params[:objective][:end_date] =   convert_datetime_pickerdate(params[:objective][:end_date])
    end
  end

  def convert_datetime_pickerdate(chosen_date)    
    Time.strptime(chosen_date,"%m/%d/%Y %H:%M %p %Z") unless chosen_date.nil? or chosen_date.empty?
  end
  
  def organizations
    @available_organizations = MedicalOrganization.where_active().select("id,name").collect {|org| [org.name, org.id]}
  end
  
end

