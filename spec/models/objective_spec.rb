# == Schema Information
#
# Table name: objectives
#
#  id         :integer          not null, primary key
#  name       :string(75)       not null
#  status     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Objective do
  context "Mass assignment" do
    it { should allow_mass_assignment_of(:name)}
    it { should allow_mass_assignment_of(:suspended)}
    it { should allow_mass_assignment_of(:start_date)}
    it { should allow_mass_assignment_of(:end_date)}
    it { should_not allow_mass_assignment_of(:status)}
    it { should_not allow_mass_assignment_of(:created_at)}
    it { should_not allow_mass_assignment_of(:updated_at)}
  end

  context "Validations" do
    it { should validate_presence_of(:name)}
    it { should ensure_length_of(:name).is_at_most(50)}
    it { should validate_uniqueness_of(:name)}
  end


  describe "Pagination"  do
    before do
      25.times.each do
        Fabricate(:objective)
      end
      @records = Objective.all
    end

    context "First page" do
      before do
        @recs = Objective.list(1)
      end

      it "should return 15 records on first page" do
        @recs.should have(15).items
      end

      it "should include the first record" do
        @recs.should include @records.first
      end

      it "should include 15th record" do
        @recs.should include @records[14]
      end

      it "should not include 25th record" do
        @recs.should_not include @records.last
      end
    end

    context "Last page" do
      before do
        @recs = Objective.list(2)
      end

      it "should return 10 records on last page" do
        @recs.should have(10).items
      end

      it "should not include the first record" do
        @recs.should_not include @records.first
      end

      it "should include 16th record" do
        @recs.should include @records[15]
      end

      it "should include 25th record" do
        @recs.should include @records.last
      end
    end
  end

  context "#change_toggle_status"  do
    before do
      @objective1 = Fabricate(:objective,:status =>false)
      @objective2 = Fabricate(:objective)
      @objective3 = Fabricate(:objective)
      @exam_question = Fabricate(:exam_question,:objective_id => @objective3.id)
    end
    it "should change the status of a objective to true" do
      @objective1.change_toggle_status.should be_true
    end

    it "should change the status of a objective to false" do
      @objective2.change_toggle_status.should be_true
    end

    it "should not allow to change the status of a objective" do
      @objective3.change_toggle_status.should be_false
    end
  end

  # context "let's see" ,:focus => true do
  #    objective = Fabricate(:objective,:suspended=> true) 
  #     raise objective.after_find.inspect
  # end


end
