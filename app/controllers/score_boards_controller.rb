class ScoreBoardsController < ApplicationController
  include BeltExtension
  before_filter :authenticate_user!
  def create
    filters = eval(params[:search])

    options= {:exam_question=>params[:exam_question_id], :score_board=>params[:score_board], :medical_case=>params[:medical_case_id]}
    score_board = ScoreBoard.exam_question_result(current_user,options)

    filters[:question]= score_board.exam_question_id

    score_board.save
    update_belt
    if score_board.exam_mode =="sparring_mode" and !params[:page].present?
      redirect_to sparring_mode_exam_questions_path(:id=>score_board.medical_case_id, :question=>score_board.exam_question_id)
    elsif score_board.exam_mode =="exam_mode"
      redirect_to exam_mode_exam_questions_path(:params=>filters)
    else
      redirect_to sparring_mode_exam_questions_path(:params=>filters)
    end
  end

  def update
    filters = eval(params[:search])
    options= {:medical_case=>params[:medical_case_id],:exam_question=>params[:exam_question_id], :score_id=> params[:id], :score_board=>params[:score_board]}
    score_board = ScoreBoard.sparring_records(options)
    if score_board.exam_mode =="sparring_mode" and !params[:page].present?
      redirect_to sparring_mode_exam_questions_path(:id=>score_board.medical_case_id, :question=>score_board.exam_question_id)
    else
      redirect_to sparring_mode_exam_questions_path(:params=>filters)
    end
  end
end