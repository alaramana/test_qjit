class ApplicationController < ActionController::Base
  def forem_user
    current_user
  end
  helper_method :forem_user

  protect_from_forgery

  before_filter :banned?, :check_token, :set_time_zone

  layout :detect_layout

  def  check_token
    if  params[:controller]== "devise/registrations" && params[:action]=="new"
      invite_token=  params[:invitation_token]
      invitation_status = Invite.find_by_invitation_token_and_status(invite_token,false)
      if invitation_status.present?
        if invitation_status.expired?
          redirect_to root_path, alert: "Request expired, request a new one"
        end
      else
        redirect_to root_path, alert: "Enter valid URL"
      end
    end
  end

  def detect_layout
    current_user.nil? ? "login" : "application"
  end

  rescue_from Exception, :with => :render_error
  def render_error(e)
    if [ActionController::RoutingError,CanCan::AccessDenied, ActionView::Template::Error, ActiveRecord::RecordNotFound, ActionView::MissingTemplate].include?(e.class)
      render :template => "404", :formats =>:html, :handlers =>:haml, :status => 404, :layout => (current_user ? 'application' : 'login')
    else
      raise e
    end
  end

  def banned?
    if current_user.present? && !current_user.active?
      sign_out current_user
      root_path
    end
  end


  def return_objects(params)
    return ExamQuestion.search(params[:search]),OpenStruct.new(params[:search]),MedicalCase.new,ExamQuestion.new
  end

  def set_time_zone
    Time.zone = current_user.time_zone if current_user
  end
end

