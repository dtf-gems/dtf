# encoding: UTF-8

# AnalysisCase defines the 'test premise', which is broken down into steps called CaseTests
#
# AnalysisCases own CaseTests. Users own each CaseTest through its AnalysisCase
class AnalysisCase < ActiveRecord::Base

  attr_accessible :name, :description
  validates_presence_of :name, :description

  belongs_to  :verification_suite, :autosave => :true
  belongs_to  :user, :autosave => :true
  has_many :case_tests, :include => :verification_suites, :dependent => :destroy

end
