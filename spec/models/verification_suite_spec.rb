# encoding: UTF-8

require 'spec_helper'

describe "VerificationSuite" do

  context "when instantiated" do

    it "should be the proper class" do
      Fabricate.build(:verification_suite).should be_a(VerificationSuite)
    end

    it "should be invalid without a name" do
      Fabricate.build(:verification_suite, name: nil).should_not be_valid
    end

    it "should be invalid without a description" do
      Fabricate.build(:verification_suite, description: nil).should_not be_valid
    end

    it "should be invalid without being assigned to a user" do
      user = Fabricate.build(:user)
      verification_suite = user.verification_suites.build(name: "RSpec Test VS", description: nil)
      verification_suite.should_not be_valid
    end

    it "should not be saved" do
      Fabricate.build(:verification_suite).new_record?.should be_true
    end

  end

  context "when created" do
    user = Fabricate(:user)
    verification_suite = user.verification_suites.create(name: "RSpec Test VS", description: "Bogus VS for RSpec")
    user.verification_suites.count.should == 1

    it "should be owned by a user" do
      verification_suite.user_id.should_not be_nil
    end

    it "should have a valid name and description" do
      verification_suite.should be_valid
    end

    it "should be saved" do
      verification_suite.new_record?.should_not be_true
      verification_suite.persisted?.should be_true
    end
  end
end
