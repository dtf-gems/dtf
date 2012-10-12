# encoding: UTF-8

require 'spec_helper'

describe "AnalysisCase" do

  context "when instantiated" do
    
    it "should be the proper class" do      
      Fabricate.build(:analysis_case).should be_a(AnalysisCase)      
    end

    it "should be invalid without a name" do    
      Fabricate.build(:analysis_case, name: nil).should_not be_valid
    end  
  
    it "should be invalid without a description" do    
      Fabricate.build(:analysis_case, description: nil).should_not be_valid
    end
        
    it "should be invalid without being assigned to a verification suite" do
      analysis_case = Fabricate.build(:analysis_case)
      analysis_case[:verification_suite_id].should be_nil
    end
    
    it "should not be saved" do
      Fabricate.build(:analysis_case).new_record?.should be_true
    end

  end  
  
  context "when created" do
    user = Fabricate(:user)
    vs = user.verification_suites.create(name: "RSpec Test VS", description: "Bogus VS for RSpec")
    analysis_case = vs.analysis_cases.create(name: "RSpec Test AC", description: "Bogus AC for RSpec")
      
    it "should be owned by a verification suite" do    
      analysis_case.verification_suite_id.should_not be_nil
    end  

    it "should have a valid name and description" do    
      analysis_case.should be_valid
    end  
  
    it "should be saved" do
      analysis_case.new_record?.should_not be_true
      analysis_case.persisted?.should be_true
    end
  end
end
