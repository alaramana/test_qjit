class CommentsController < ApplicationController
  include MedicalCasesHelper
  def create
    if params[:medical_case_id]
      @medical_case      = MedicalCase.find(params[:medical_case_id])
      @comment           = @medical_case.comments.new(params[:comment])
      @comment.user_id   = current_user.id
      @comment.save
    else
      @question         = ExamQuestion.find(params[:exam_question_id])      
      @comment          = @question.comments.new(params[:comment])
      @comment.user_id  = current_user.id
      @comment.save
    end
      user = User.find(@comment.user_id)
      user.update_column(:comments_count, user.comments.count)

    respond_to do |format|
      format.js
    end
  end
end
