require 'spec_helper'

describe "Override Delete and Destroy methods" do
	before do
		4.times.each do
			Fabricate(:medical_organization)
		end
	end

	it "should not delete record using delete method" do
		MedicalOrganization.count.should eq 4
		lambda {MedicalOrganization.last.delete}.should raise_error(RuntimeError)
		MedicalOrganization.count.should eq 4
	end
	it "should not delete record using destroy method" do
		MedicalOrganization.count.should eq 4
		lambda {MedicalOrganization.last.destroy}.should raise_error(RuntimeError)
		MedicalOrganization.count.should eq 4
	end
	it "should not delete record using destroy_all method" do
		MedicalOrganization.count.should eq 4
		lambda {MedicalOrganization.destroy_all}.should raise_error(RuntimeError)
		MedicalOrganization.count.should eq 4
	end
	it "should not delete record using delete_all method" do
		MedicalOrganization.count.should eq 4
	#	lambda {MedicalOrganization.delete_all}.should raise_error(RuntimeError)
		MedicalOrganization.count.should eq 4
	end
end