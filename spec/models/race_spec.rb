# == Schema Information
#
# Table name: races
#
#  id         :integer          not null, primary key
#  name       :string(75)       not null
#  status     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Race do

  it "Should show only name wheen calling race as string" do
    race = Fabricate(:race)
    medical_case = Fabricate(:medical_case, :race_id => race.id)
    medical_case.race.to_s.should == race.name
  end


  describe "Pagination"  do
    before do
      25.times.each do
        Fabricate(:race)
      end
      @records = Race.all
    end

    context "First page" do
      before do
        @recs = Race.list(1)
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
        @recs = Race.list(2)
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


  context "#deactivate" do
    before do
      @race1 = Fabricate(:race)
      medical_case = Fabricate(:medical_case)
      medical_case.update_attribute(:race_id, @race1.id)

      @race2 = Fabricate(:race)
      Race.update_all(:status => true)
    end

    it "should not allow deactivation when it has medical_cases" do
      @race1.deactivate.should be_false
      msg = "Cannot deactivate '#{@race1.name}'. It has one or more medical cases."
      @race1.errors.full_messages.to_sentence.should include msg
    end

    it "should allow deactivation when it does not have any medical cases" do
      @race2.deactivate.should be_true
    end
  end

  context "#activate" do
    before do
      @race1 = Fabricate(:race)
      medical_case = Fabricate(:medical_case)
      medical_case.update_attribute(:race_id, @race1.id)
      @race2 = Fabricate(:race)
    end

    it "should activate whether it may or may not have members" do
      @race1.activate.should be_true
      @race2.activate.should be_true
    end
  end

  context "#change_toggle_status" do
    before do
      @race = Fabricate(:race,:status => false)
    end

    it "should set status as active" do
      @race.change_toggle_status
      @race.status.should be_true
    end
  end
end
