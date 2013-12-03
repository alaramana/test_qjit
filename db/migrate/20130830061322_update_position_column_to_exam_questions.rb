class UpdatePositionColumnToExamQuestions < ActiveRecord::Migration
  
  def up
    questions = ExamQuestion.where(:position=>nil)
    if questions.present?
      questions.find_each do |qt|        
        qt.update_attribute(:position, ([0,1,2,3,4].sample(5)))        
      end
    end
  end

  def down
  end
end
