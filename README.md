[![Build Status](https://travis-ci.org/dtf-gems/dtf.png?branch=master,stable)](https://travis-ci.org/dtf-gems/dtf)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/dtf-gems/dtf)

# Deryls Testing Framework
DTF is designed to be a modular framework for testing everything from shell scripts, to Ruby, to Rails apps.

DTF is an umbrella which is designed to incorporate multiple sub-gems, each of which provides additional functionality to DTF. DTF is the master skeleton within which all other dtf-* gems integrate.

## Internal architecture
DTF is designed in such a way that, with the master skeleton in place, one has only to load additional plugins from any available DTF extension gem to add additional functionality. This can be anything ranging from additional languages such as Ruby, Python, C, C++, etc, to testing methods and methodologies.

## Supported Ruby Implementations
Currently, DTF supports the following Ruby implementations:

  - [Rubinius](https://github.com/rubinius/rubinius)
  - [MRI](https://github.com/ruby/ruby) [Matz's Ruby Implementation]
  - [JRuby](https://github.com/jruby/jruby)

DTF only supports v1.9 under each implementation. v1.8 is *not* supported! *DTF will not backport v1.8 support!*

## Current Status
DTF is 100% Alpha quality right now. For those that do not know what that means, generally this means DTF is comprised of code with a vastly high potential for buggy code that may or may not even run. Consider DTF to be experimental until further notice. This README will be updated to reflect when DTF reaches a   'stable' quality.

DTF will gladly, and willingly, review any Pull Requests sent to us, and incorporate them as they fit with the mission goal of DTF. Please bear in mind that DTF is a rolling Project. This means that the definition of what DTF is, and how that is implemented is not firmly etched in stone yet, so both of those can, and most likely will, change as time passes. If you can deal with that, please, by all means, feel free to contribute.

**NOTE: DTF was originally released with a soon-to-be 100% different codebase, and gemified. This version will be gemified as well, _but_ in order to ensure that we can continue to use the 'dtf' name on rubygems.org we have to bump the version number by .1 and go from there. So, that changes our new numbering scheme a bit. The next release of 'dtf' that will be 100% the _new_ codebase will be 0.2.2. The last 'dtf' that is the original code base is: dtf-0.2.1 on rubygems.org. Thanks for bearing with DTF while the codebase change is swapped over.

## Branches
DTF has a branching and tagging topology as follows, and applies to DTF and _all_ sub-module gems:

  - master - This branch on the DTF control gem, and _all_ dtf-<blah> sub-module gems is for **development**
    
  - stable - This branch on the DTF gem, and _all_ dtf-<blah> sub-modules, is 'stable' or 'production' quality. Anything on this branch is to be considered safe and usable for everyday stuff.

  - hotfix/>blah> branches are **stable** quality only. These are for running fixes to a particular stable branch and will usually result in generating a new version tag. For example, if the hotfix was applied against v2.3.4, then a tag of v2.3.5 would be generated once that hotfix was proven to be tested and stable.

  - feature/<blah> branches are **development** quality only. This is for work on individual new features that _will_ be rolled into DTF or sub-module gems.

  - playground/<blah> branches are **alpha** quality only. These are for developers to work out either feasibilty of way-in-the-future ideas or to try something out that may, or may not, be incorporated into the DTF or its sub-modules. _These are 100% to be considered throw-aways. They could disappear at any moment, and any user of the DTF framework that relies on these branches is on their own. NO SUPPORT will be provided of any kind for these branches_ so everyone is clear on that.

  - All 'stable' production releases will be tagged. Only those releases will be tagged starting with a v, and a series like #.#.#  where the first '#' starts with 1 going to whatever, in progressive order. This represents an industry standard versioning format. NOTE: v0.#.# is NOT considered a 'stable' release! This is normal in the industry for Projects just starting out. When a version is reached that we believe to be of sufficient quality to be denoted, and tagged, as our first Stable release, it will be marked as v1.#.# and NOT v0.#.#. The remaining '#' in the example denote our Minor, and Change '#' levels. For example, #.#.# is Major.Minor.Change_Number_within_Minor. 	This means the following. Given a 'v2.3.4' tag,this would denote:
    
    - The 2nd official 'stable' release.
    - The 3rd Minor change to the 2.x series
    - The 4th applied change within the 3rd Minor series.

Until such time as the first official stable release is made, all v0.#.# tags up to but not including v0.5.0 are of Alpha quality. Tags v0.5.# up to but not including v1.0.0 are to be considered Beta quality. This gives us plenty of room for Alpha _and_ Beta work before an official 'stable' release within the numbering system.

  **This applies to the DTF control gem, and _all_ dtf-<blah> sub-module gems! Please bear this in mind!**

We are making this a uniform policy across all levels of DTF to ensure that what you think something is, really is when it comes to version numbers and what they mean. This _will_ be a _strictly_ enforced policy.

## Installation
DTF uses Thor for setup and configuration, and has 3 possible sub-tasks under task name 'dtf_setup':

```sh
$ thor list
dtf_setup
---------
thor dtf_setup:config [NAME]  # Copy db configuration file(s)
thor dtf_setup:install        # Installs database migrations, the main schema, and configuration files
```

As you can see, you can copy just the db config files, and/or the migrations, and main schema.

```sh
$ thor help dtf_setup
Tasks:
  thor dtf_setup:config [NAME]  # Copy db configuration file(s)
  thor dtf_setup:help [TASK]    # Describe available tasks or one specific task
  thor dtf_setup:install        # Installs database migrations, the main schema, and configuration files
```

To see how to install everything you would run the following command:

```sh
$ thor dtf_setup:help install
Usage:
  thor dtf_setup:install

Options:
  [--force]

Installs database migrations, the main schema, and configuration files
```

To see how to install just the configuration files for accessing the database(s), you would run:

```sh
$ thor dtf_setup:help config
Usage:
  thor dtf_setup:config [NAME]

Options:
  [--force]

Copy db configuration file(s)
```

Once the configuration files and/or database migrations are in place, the remaining setup is handled by 'rake'. To see all possible commands, you would run 'rake -T', and pick the one(s) you need.

```sh
$ rake -T
rake build              # Build dtf-0.2.2.gem into the pkg directory
rake db:create          # Create the database from config/database.yml for the current Rails.env (use db:create:all to create all dbs i...
rake db:drop            # Drops the database for the current Rails.env (use db:drop:all to drop all databases)
rake db:fixtures:load   # Load fixtures into the current environment's database.
rake db:migrate         # Migrate the database (options: VERSION=x, VERBOSE=false).
rake db:migrate:status  # Display status of migrations
rake db:new_migration   # Create a new migration
rake db:rollback        # Rolls the schema back to the previous version (specify steps w/ STEP=n).
rake db:schema:dump     # Create a db/schema.rb file that can be portably used against any DB supported by AR
rake db:schema:load     # Load a schema.rb file into the database
rake db:seed            # Load the seed data from db/seeds.rb
rake db:setup           # Create the database, load the schema, and initialize with the seed data (use db:reset to also drop the db first)
rake db:structure:dump  # Dump the database structure to db/structure.sql. Specify another file with DB_STRUCTURE=db/my_structure.sql
rake db:version         # Retrieves the current schema version number
rake install            # Build and install dtf-0.2.2.gem into system gems
rake release            # Create tag v0.2.2 and build and push dtf-0.2.2.gem to Rubygems
```


## Usage
Once you have finished configuring your database(s) and applying all migrations, you are now ready to work with DTF directly. The following is a summary of all current possible commands, and their expected options/parameters:

```sh
dtf -v|--version -h|--help [[sub_cmds <options>] -h|--help]

Valid [sub_cmds] are: create_(user|vs), delete_(user|vs)
See 'dtf [sub_cmd] -h' for each sub_cmd's details and options

dtf create_user -h
Options:
      --user-name, -u <s>:   Username for new TF user - REQUIRED
      --full-name, -n <s>:   Real name for new TF user - REQUIRED
  --email-address, -e <s>:   Email address for new TF user - REQUIRED
               --help, -h:   Show this message

dtf delete_user -h
Options:
               --user-name, -u <s>:   Username of TF user to delete - REQUIRED
  --delete-all, --no-delete-all, -d:   Delete _all_ VSs this user owns (default: true)
                         --help, -h:   Show this message

dtf create_vs -h
Options:
    --user-name, -u <s>:   TF user to associate this VS with - REQUIRED
         --name, -n <s>:   Name for new VS - REQUIRED
  --description, -d <s>:   Description of VS's intended use - OPTIONAL (default: )
             --help, -h:   Show this message

dtf delete_vs -h
Options:
  --user-name, -u <s>:   Username of VS owner - REQUIRED
         --id, -i <i>:   ID of VS to be deleted - REQUIRED
           --help, -h:   Show this message
```

An unlisted command is 'setup_dtf'. This command is for use by sub-gems in the DTF framework. It copies the thor task from DTF's master gem 'dtf' to the proper directory in the sub-gem, or a project that makes use of the dtf master gem. It is referenced, but not shown here, for that reason.

Enjoy!
