module ApplicationHelper

  def activate_admin_menu(controller)
    ["admin/medical_organizations", "admin/users", "admin/reports", "admin/races", "admin/objectives"].include?(controller) ? "active" : nil
  end

  def set_title_to_active(active)
    active == true ? "Deactivate" : "Activate"
  end

  def can_register?(invite_token)
    invitation = Invite.find_by_invitation_token(invite_token.strip)
    invitation.expired?
    invitation_status = Invite.find_by_invitation_token_and_status(invite_token,false)
    if invitation.expired?
      return false
    elsif invitation_status
      return invitation
    else
      return false
    end
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)",:class => "btn delete-btn btn-danger btn-small" )
  end


  def link_to_add_table_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_table_fields(this, '#{association}', '#{escape_javascript(fields)}')" )
  end

  def user_belt(color)
    case color
    when "white" then
      "belt-white"
    when "blue" then
      "belt-blue"
    when "black" then
      "belt-black"
    when "purple" then
      "belt-purple"
    when "brown" then
      "belt-brown"
    when "red" then
      "belt-red"
    end
  end
  
  def  question_answer_history_icons(answer)
    if answer.nil?
      "question-sign"
    elsif answer==true
      "check-sign"
    elsif answer==false
      "x-sign"
    end
  end

  def is_favorite(user, mcase)    
    fav= user.favorites.collect(&:medical_case_id).include?(mcase) 
    if fav
      "cstar"
    else
      "cstar gray"
    end
  end

  def is_question_favorite(user, question)
    fav= user.favorites.collect(&:exam_question_id).include?(question)    
    if fav
      "cstar"
    else
      "cstar gray"
    end
  end


 
  def medical_case_rating(rate)   
    return fist_rating(rate)
  end

  def exam_medical_case_rating(mcase, user)
    if mcase.ratings.collect(&:user_id).include?(user.id)
     rate = mcase.ratings.find_by_user_id(user.id).rate
      return fist_rating(rate)
    end
  end

  def exam_question_rating(question, user)
    if question.ratings.collect(&:user_id).include?(user.id)
      rate = question.ratings.find_by_user_id(user.id).rate
      fist_rating(rate)
    end
  end

  def medical_case_average_rating(mcase)
    rate = mcase.average_rating.round
    return fist_rating(rate)
  end

  def exam_question_average_rating(question)
    rate = question.average_rating.round
    return fist_rating(rate)
  end

  def fist_rating(rating)
    rating = rating.round.to_i
    case rating
      when 1 then "value fist one"
      when 2 then "value fist two"
      when 3 then "value fist three"
      when 4 then "value fist four"
      when 5 then "value fist five"
    end
  end

  def number_of_exam(user, exam_mode)
    user.score_boards.where(:exam_mode=>exam_mode).group_by(&:exam_number).sort.reverse.size
  end

  def total_questions(user, exam_mode)
    user.score_boards.where(:exam_mode=>exam_mode).size
  end

  def user_high_score(user)
    score = user.score_boards.where(:correct=>"true").group_by(&:exam_number).sort.reverse
    sc = []
    score.each do |test, exam|
      sc << exam.collect(&:correct).size
    end
    if sc.present?
      sc.max
    else
      0
    end
  end

  def user_report_high_score(user, exam_mode)

    score = user.score_boards.where(:exam_mode=> exam_mode, :correct=>"true").group_by(&:exam_number).sort.reverse
    sc = []
    if score.present?
      score.each do |test, exam|
        sc << exam.collect(&:correct).size
      end
      sc.max
    else
      0
    end
  end

  ### Helper method to display timestamp.  Defaults to QJIT-107 format, but override-able as needed
  def display_time(time,format = :qjitsu_standard)
    format = case format
    when :qjitsu_standard
      "%b %d, %Y %I:%M %p %Z"
    when :B_e_Y
      "%B %e, %Y"      
    when :datetime_picker
      "%m/%d/%Y %I:%M %p %Z"
    else 
      format
    end

    if(time.present?)
      time.in_time_zone.strftime(format)
    end
  end

  def varify_invitation_token(invitation_token)
    Invite.find_by_invitation_token(invitation_token)
  end

  def fancy_status(a) #display assignment(objective) status with date if applicable)
    message = a.status
    if(a.status=="Open")
      message << "<span class=\"muted\"> (Closing in "+distance_of_time_in_words(a.end_date,Time.now)+")</span>" if a.end_date
    elsif(a.status=="Pending")
      message << "<span class=\"muted\"> (Opens in "+distance_of_time_in_words(a.start_date,Time.now)+")</span>"
    end
    return message.html_safe
  end

end

