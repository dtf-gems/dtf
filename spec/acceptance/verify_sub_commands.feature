Feature: Verify sub commands
  In order to ensure each sub-command works
  As a User
  I want to execute each command successfully

  Background:
	Given I have dtf installed
	
  Scenario: Execution of create_user succeeds
    Given I execute 'create_user'
    Then I should find 'testuser' in the database

  Scenario: Execution of delete_user succeeds ( WITHOUT setting --no-delete-all flag [Default] )
    send "I execute 'create_user'"
	Given I execute 'delete_user'
	Then I should not find 'testuser' in the database

  Scenario: Execution of delete_user succeeds ( WITH setting --no-delete-all flag )
    send "I execute 'create_user'"
	Given I execute 'delete_user' setting --no-delete-all
	Then I should not find 'testuser' in the database

  Scenario: Execution of create_vs succeeds
    send "I create 'create_user'"
    Given I execute 'create_vs'
    Then I should find a VS in the database
  
  Scenario: Execution of delete_vs succeeds
    send "I execute 'create_user'"
    Given I execute 'delete_vs'
    Then I should not find a VS in the database  
