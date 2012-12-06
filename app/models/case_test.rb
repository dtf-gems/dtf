# encoding: UTF-8

# CaseTest is the recording of each individual step of an AnalysisCase's 'test premise'
class CaseTest < ActiveRecord::Base

  attr_accessible :description, :cmd
  validates_presence_of :description, :cmd

  belongs_to  :analysis_case, :autosave => :true
  has_one     :verification_suite, :through => :analysis_case, :include => :verification_suites, :autosave => :true
end
