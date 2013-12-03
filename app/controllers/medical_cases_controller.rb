class MedicalCasesController < ApplicationController
  include MedicalCasesHelper
  before_filter :authenticate_user!
  layout  "medical_cases"

  def index
    @search        = MedicalCase.all_models.search(params[:search])
    @filters       = OpenStruct.new(params[:search])
    @medical_cases = MedicalCase.list(current_user,params)
    @tags_count    = MedicalCase.where(:status=>"approved").tag_counts.size
    @qcount        = ExamQuestion.where(:status=>"approved").count

    @medical_case  = MedicalCase.new
    new_form
  end

  def edit
    @active_races =   Race.where(:status=>true)
    @medical_case = MedicalCase.find(params[:id])
    form_build
    render :layout => false
  end

  def show
    @medical_case = MedicalCase.find(params[:id])
  end

  def new
    @active_races =     Race.where(:status=>true)
    @medical_case = MedicalCase.new
    new_form
    render :layout => false
  end

  def create
    filters = eval(params[:search])
    @medical_case = MedicalCase.new(params[:medical_case])
    @medical_case.creator_id = current_user.id
    if @medical_case.save
      if @medical_case.check_status(params[:status])
        redirect_to medical_cases_path(:params=>filters), notice: "Your medical case is saved as a draft. In order to edit your medical case or submit your medical case to the community, please go to  <a href='#{url_for(myprofile_user_cases_path)}'>My Profile</a>"
      else
        redirect_to medical_cases_path(:params=>filters), notice:"#{current_user.role_id ==3 ? 'Medical case was successfully created. It moved for admin approval.' : 'Medical case was successfully created. It moved for approval.'}"
      end
    else
      redirect_to medical_cases_path(:params=>filters), alert: 'Medical case name already taken.'
    end
  end

  def update
    @medical_case = MedicalCase.find(params[:id])
    if @medical_case.update_attributes(params[:medical_case])
      if params[:status]!="draft"
        @medical_case.update_column(:status, "pending")
        redirect_to medical_cases_path, notice:"#{current_user.role_id ==3 ? 'Medical case was successfully created. It moved for admin approval.' : 'Medical case was successfully created. It moved for approval.'}"
      else
        redirect_to medical_cases_path, notice: "Your medical case is saved as a draft. In order to edit your medical case or submit your medical case to the community, please go to  <a href='#{url_for(myprofile_user_cases_path)}'>My Profile</a>"
      end
    end
  end


  def autocomplete_author_name
    render json: MedicalCase.auto_complete_author(params[:name])
  end

  def autocomplete_tag_name
    render json: MedicalCase.auto_complete_tag(params[:name])
  end

  def ratings
    @user_rate =    current_user.ratings.find_by_medical_case_id(params[:idBox])
    if @user_rate.nil?
      Rating.create(:medical_case_id=>params[:idBox], :user_id=>current_user.id, :rate=>params[:rate])
      user = User.find(current_user.id)
      user.update_column(:ratings_count, user.ratings.count)
    else
      @user_rate.update_column(:rate, params[:rate])
    end
    Rating.calculate_case_average
    render :json => @user_rate
  end



  def add
    @favorite =Favorite.create(:user_id=>current_user.id, :medical_case_id=> params[:id], :is_active=>true)
    render :json => @favorite
  end

  def remove
    @favorite = Favorite.find_by_user_id_and_medical_case_id(current_user.id, params[:id])
    @favorite.destroy
    render :json => @favorite
  end

  def approved
    MedicalCase.approved_cases(params)
    if params[:admin]
      redirect_to user_cases_admin_users_url, notice: 'Case is approved.'
    else
      redirect_to medical_cases_path, notice: 'Case is approved.'
    end
  end

  def draft
    @medical_case_status = MedicalCase.find(params[:id])
    @medical_case_status.draft!
    if params[:admin]
      redirect_to user_cases_admin_users_url, notice: "Case '#{@medical_case_status.title}' status changed as draft."
    else
      redirect_to medical_cases_path , notice: "Case '#{@medical_case_status.title}' status changed as draft."
    end
  end

  def pending
    @medical_case_status = MedicalCase.find(params[:id])
    @medical_case_status.pending!
    if params[:admin]
      redirect_to user_cases_admin_users_url, notice: "Case '#{@medical_case_status.title}'  is pending."
    else
      redirect_to medical_cases_path, notice: "Case '#{@medical_case_status.title}'  is pending."
    end
  end

  def inactive
    @medical_case_status = MedicalCase.find(params[:id])
    @medical_case_status.inactive!
    if params[:admin]
      redirect_to user_cases_admin_users_url,  notice: "Case '#{@medical_case_status.title}' is deactivated."
    else
      redirect_to medical_cases_path , notice: "Case '#{@medical_case_status.title}' is deactivated."
    end
  end


  def get_comments
    @mcase =MedicalCase.find(params[:id])
    render :layout=> false
  end 

  def get_tags
    @mcase = MedicalCase.find(params[:id])
    render :layout=> false
  end

end
