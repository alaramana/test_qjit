class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  handles_sortable_columns

  # GET /users
  # GET /users.json
  def index
    @filters = OpenStruct.new(params[:search])

    if @filters.active_is_true =="active"
      @users  = User.where(:active=>true).list(params[:page])
    elsif @filters.active_is_true =="suspend"
      @users  = User.where(:active=>false).list(params[:page])
    else
      @users  = User.list(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
      format.js
    end
  end

  # GET /users/1/edit
  def edit
    @acitve_medical_organizations = MedicalOrganization.where(:status=>true).collect {|x| [x.name, x.id]}

    @states = State.all.collect {|x| [x.name, x.id]}
    @all_roles = Role.all.collect {|x| [x.name, x.id].compact unless x.id == 1 }
    @user = User.find(params[:id])
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to '/admin/users', notice: "User updated successfully"
    else
      render "edit"
    end
  end

  def toggle_status
    @user = User.find(params[:user_id])
    @user.update_attribute("active",  !@user.active)
    redirect_to admin_users_path,
    notice: @user.active == false ? "'#{@user.full_name}' is deactivated." : "'#{@user.full_name}' is activated."
  end


  def send_invite
    @invite = current_user.invite_user(params[:invite][:email],params[:invite][:role_id],params[:invite][:medical_organization_id])
    if @invite.save
      @invite.invitor_name = @invite.user.full_name
      @invite.medical_organization_name = @invite.medical_organization.name
      @invite.role_name = @invite.role.name
      @invite.save
      @invite.send_mail(current_user)
      redirect_to invitations_admin_users_path, notice: "Invitation has been sent to #{@invite.email}."
    else
      redirect_to invitations_admin_users_path, alert: @invite.errors
    end
  end


  def resend_invite
    invite = Invite.find(params[:invite][:id])
    invite.updated_at = Time.now.utc
    invite.save
    invite.send_mail(current_user)
    redirect_to invitations_admin_users_path, notice: "Invitation has been sent to #{invite.email}."
  end

  def invitations
    @acitve_medical_organizations = MedicalOrganization.where(:status=>true).collect {|x| [x.name, x.id]}

    @filters = OpenStruct.new(params[:search])
    order = sortable_column_order
    if  @filters.status_is_true =="joined" && order
      @invitations = Invite.where(:status=>true).list(params[:page]).order(order)
    elsif @filters.status_is_true =="pending" && order
      @invitations = Invite.where(:status=>false).list(params[:page]).order(order)
    elsif   @filters.status_is_true =="joined"
      @invitations = Invite.where(:status=>true).list(params[:page]).order("updated_at DESC")
    elsif @filters.status_is_true =="pending"
      @invitations = Invite.where(:status=>false).list(params[:page]).order("updated_at DESC")
    elsif order
      @invitations = Invite.list(params[:page]).order(order)
    else
      @invitations = Invite.list(params[:page]).order("updated_at DESC")
    end
  end


  def remove_pending_invitaion
    invite = Invite.find(params[:invite_id])
    invite.destroy
    redirect_to invitations_admin_users_path, notice: "Invitation has been removed successfully."
  end


  def user_cases
    @filters = OpenStruct.new(params[:search])
    unless !@filters.user_firstname_contains.present?
      names= @filters.user_firstname_contains.split(' ') 
      firstname, lastname  = names
      params[:search][:user_firstname_contains] = firstname
      params[:search][:user_lastname_contains]  = lastname
    end
    params[:search][:title_contains] = @filters.title_contains.strip unless !@filters.title_contains.present?
    @search =MedicalCase.all_models.search(params[:search])
    @medical_cases = @search.order('created_at DESC').page(params[:page])
  end

end
