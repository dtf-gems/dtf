# encoding: UTF-8

step "I have dtf installed" do
  if Dtf::VERSION.empty?
    fail("DTF gem not loaded")
  end
end

step "I request help for sub-command :sub_cmd" do |cmd|
  @cmds = {}
  @cmds[cmd] = ''
end

step "I should see :help_response in the response" do |help_response|
  @cmds.each do |cmd|
    cmd[1] = "#{help_response}"
    result = %x[bundle exec dtf #{cmd[0]} -h]
    result.should include("#{cmd[1]}")
  end
end

step "I execute 'create_user'" do
  @cmd = "create_user"
  @cmd_opts = {user_name: "testuser", 
              full_name: "My Test User",
              email_address: "me@example.com",
              user_name_given: true,
              full_name_given: true,
              email_address_given: true
              }

  new_cmd = Dtf::Command.create_cmd(@cmd, @cmd_opts)
  new_cmd.execute
end

step "I should find 'testuser' in the database" do
  user = User.find_by_user_name('testuser')
  user.should_not be_nil
end

step "I execute 'delete_user'" do
  send "I execute 'create_user'"

  @cmd = "delete_user"
  @cmd_opts = { user_name: "testuser",
                user_name_given: true,
                delete_all: true
                }
  new_cmd = Dtf::Command.create_cmd(@cmd, @cmd_opts)
  new_cmd.execute
end

step "I execute 'delete_user' setting --no-delete-all" do
  send "I execute 'create_user'"

  @cmd = "delete_user"
  @cmd_opts = {user_name: "testuser", 
              user_name_given: true,
              delete_all: false,
              delete_all_given: true
              }

  new_cmd = Dtf::Command.create_cmd(@cmd, @cmd_opts)
  new_cmd.execute
end

step "I should not find 'testuser' in the database" do
end

step "I execute 'create_vs'" do
  send "I execute 'create_user'"
  @cmd = "create_vs"
  @cmd_opts = {user_name: "testuser",
              name: "My Test VS",
              description: "Bogus VS for testing",
              user_name_given: true,
              name_given: true,
              description_given: true
              }

  new_cmd = Dtf::Command.create_cmd(@cmd, @cmd_opts)
  new_cmd.execute

end

step "I should find a VS in the database" do
  user = User.find_by_user_name('testuser')
  user.verification_suites.should_not be_empty
end

step "I execute 'delete_vs'" do
  send "I execute 'create_vs'"
  @cmd = "delete_vs"
  @cmd_opts = {user_name: "testuser",
              id: 1,
              user_name_given: true,
              id_given: true
              }
  new_cmd = Dtf::Command.create_cmd(@cmd, @cmd_opts)
  new_cmd.execute
end

step "I should not find a VS in the database" do
  user = User.find_by_user_name('testuser')
  user.verification_suites.should be_empty
end
