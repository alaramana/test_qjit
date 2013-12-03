class MyprofileController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @acitve_medical_organizations = MedicalOrganization.where(:status=>true).collect {|x| [x.name, x.id]}
    @states = State.all.collect {|x| [x.name, x.id]}
    @user = current_user
  end

  def update
    @user = current_user

    if params[:user][:password].nil?
      email = params[:user][:email]
      already= Invite.find_by_email(email)
      if already
        redirect_to myprofile_url, alert: "Email #{already.email} is already in use by another user"
      elsif  @user.update_attributes(params[:user])        
        redirect_to myprofile_url, notice: "Your profile updated successfully"  if @user.email == email
        redirect_to myprofile_url, notice: "Confirmation email sent to #{@user.unconfirmed_email}" if @user.email != email
      else
        redirect_to myprofile_url,:alert =>"#{@user.errors.full_messages.to_sentence}"
      end
    else
      if @user.update_attributes(params[:user])
        redirect_to user_session_path, notice: "Password updated successfully, please Login"
      else
        render :action => "edit"
      end
    end
  end

  def user_cases
    @filters = OpenStruct.new(params[:search])
    @search =current_user.medical_cases.all_models.search(params[:search])
    @medical_cases = @search.where(:status=>["approved","draft"]).order('created_at DESC').page(params[:page])
  end

  def exam_questions
    @filters = OpenStruct.new(params[:search])
    @search  = current_user.exam_questions.search(params[:search])
    @exam_questions = @search.order('created_at DESC').page(params[:page])
  end

  def user_history
    @sparring_mode = current_user.score_boards.where(:exam_mode=>"sparring_mode").group_by(&:exam_number).sort.reverse
    @test_mode =current_user.score_boards.where(:exam_mode=>"exam_mode").group_by(&:exam_number).sort.reverse
  end

  def routing
    render :template => "404", :formats => :html, :handlers => :haml, :status => 404, :layout => (current_user ? 'application' : 'login')
  end
end
