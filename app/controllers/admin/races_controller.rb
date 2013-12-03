class Admin::RacesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @filters = OpenStruct.new(params[:search])
    if @filters.status_is_true =="suspend"
      @races  = Race.where(:status=>false).list(params[:page])
    elsif @filters.status_is_true =="active"
      @races  = Race.where(:status=>true).list(params[:page])
    else
      @races = Race.list(params[:page])
    end
  end

  def new
    @race = Race.new
  end

  def edit
    @race = Race.find(params[:id])
  end

  def create
    @race = Race.new(params[:race])
    if @race.save
      redirect_to admin_races_path, notice: 'Race was successfully created.'
    else
      render :action =>"new"
    end
  end

  def update
    @race = Race.find(params[:id])
    if @race.update_attributes(params[:race])
      redirect_to admin_races_path, notice: 'Race was successfully updated.'
    else
      render action: "edit"
    end
  end

  def toggle_status

    @race = Race.find(params[:id])
    name                  = @race.name
    if @race.change_toggle_status
      msg = @race.status? ? "#{name} is activated." : "#{name} is deactivated."
      redirect_to admin_races_path, notice: msg
    else
      msg = @race.errors.full_messages.to_sentence
      redirect_to admin_races_path, alert: msg
    end
  end
end
