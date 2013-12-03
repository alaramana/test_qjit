class AddAttachmentPhotoToExamQuestions < ActiveRecord::Migration
  def self.up
    change_table :exam_questions do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :exam_questions, :photo
  end
end
