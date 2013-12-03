class Admin::MedicalOrganizationsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @filters = OpenStruct.new(params[:search])

    if @filters.status_is_true =="suspend"
      @medical_organizations  = MedicalOrganization.where(:status=>false).list(params[:page])
    elsif @filters.status_is_true =="active"
      @medical_organizations  = MedicalOrganization.where(:status=>true).list(params[:page])
    else
      @medical_organizations = MedicalOrganization.list(params[:page])
    end

  end


  def new
    @medical_organization = MedicalOrganization.new
  end

  def edit
    @medical_organization = MedicalOrganization.find(params[:id])
  end

  def create
    @medical_organization        = MedicalOrganization.new(params[:medical_organization])
    @medical_organization.status = true

    if @medical_organization.save
      redirect_to admin_medical_organizations_path , notice: 'Medical organization created successfully.'
    else
      render action: "new"
    end
  end

  def update
    @medical_organization = MedicalOrganization.find(params[:id])
    if @medical_organization.update_attributes(params[:medical_organization])
      redirect_to admin_medical_organizations_path, notice: 'Medical organization updated successfully.'
    else
      render action: "edit"
    end
  end

  def toggle_status
    @medical_organization = MedicalOrganization.find(params[:id])
    name                  = @medical_organization.name
    if @medical_organization.change_toggle_status
      msg = @medical_organization.status? ? "#{name} is activated." : "#{name} is deactivated."
      redirect_to admin_medical_organizations_path, notice: msg
    else
      msg = @medical_organization.errors.full_messages.to_sentence
      redirect_to admin_medical_organizations_path, alert: msg
    end
  end
end
