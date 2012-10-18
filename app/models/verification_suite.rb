# encoding: UTF-8

# VerificationSuite is the core container class. 
#
# ASSOCIATIONS BREAKDOWN: It contains many AnalysisCases. Each AnalysisCase contains 
# multiple case_tests, owned by both the User and the AnalysisCase. The goal is to 
# make 'packs' of tests which Users can share between Suites, grouped by Cases, and 
# even share those Tests between Cases. 
# 
# Also, Users should be able to share their individual Test(s), AnalysisCase(s), through 
# their VerificationSuite(s) with other Users for inclusion in their own AnalysisCase(s) 
# and Suite(s) allowing for mix-and-match batching.

class VerificationSuite < ActiveRecord::Base

  attr_accessible :name, :description
  validates_presence_of :name, :description

  belongs_to :user, :autosave => :true
  has_many :analysis_cases, :include => :case_tests, :dependent => :destroy
  has_many :case_tests, :through => :analysis_cases, :include => :analysis_cases, :dependent => :destroy

end
