# encoding: UTF-8

require 'spec_helper'

describe "CaseTest" do

  context "when instantiated" do

    it "should be the proper class" do
      Fabricate.build(:case_test).should be_a(CaseTest)
    end

    it "should be invalid without a description" do
      Fabricate.build(:case_test, description: nil).should_not be_valid
    end

    it "should be invalid without a command" do
      Fabricate.build(:case_test, cmd: nil).should_not be_valid
    end

    it "should be invalid without being assigned to an analysis case" do
      case_test = Fabricate.build(:case_test)
      case_test[:analysis_case_id].should be_nil
    end

    it "should not be saved" do
      Fabricate.build(:case_test).new_record?.should be_true
    end

  end

  context "when created" do
    user = Fabricate(:user)
    vs = user.verification_suites.create(name: "RSpec Test VS", description: "Bogus VS for RSpec")
    analysis_case = vs.analysis_cases.create(name: "RSpec Test AC", description: "Bogus AC for RSpec")
    case_test = analysis_case.case_tests.create(cmd: "bundle exec rspec spec",
                                                description: "Bogus CT for RSpec"
                                                )

    it "should be owned by an analysis case" do
      case_test.analysis_case_id.should_not be_nil
    end

    it "should have a valid cmd and description" do
      case_test.should be_valid
    end

    it "should be saved" do
      case_test.new_record?.should_not be_true
      case_test.persisted?.should be_true
    end
  end
end
