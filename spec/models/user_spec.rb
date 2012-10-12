# encoding: UTF-8

require 'spec_helper'

describe "User" do

  context "when instantiated" do

    it "should be the proper class" do
      Fabricate.build(:user).should be_a(User)
    end

    it "should be invalid without a user_name" do
      Fabricate.build(:user, user_name: nil).should_not be_valid
    end

    it "should be invalid without an email_address" do
      Fabricate.build(:user, email_address: nil).should_not be_valid
    end

    it "should be invalid without a full_name" do
      Fabricate.build(:user, full_name: nil).should_not be_valid
    end

    it "should not be saved" do
      Fabricate.build(:user).new_record?.should be_true
    end

  end

  context "when created" do
    let(:user) { Fabricate(:user)}

    it "should have a valid user_name, full_name, and email_address" do
      user.should be_valid
      user.errors.should be_empty
      user.user_name.should_not be_nil
      user.full_name.should_not be_nil
      user.email_address.should_not be_nil
    end

    it "should be saved" do
      user.new_record?.should_not be_true
      user.persisted?.should be_true
    end
  end
end
