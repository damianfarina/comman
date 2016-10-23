server 'niobe', user: 'deployer', roles: %w{web app}

set :deploy_to,       "/home/deployer/apps/comman"
set :rails_env,       "production"
set :normalize_asset_timestamps, false
set :ssh_options,     { forward_agent: true }
set :linked_files, %w{config/database.yml}
set :unicorn_workers, 2

# set :migrate_target,  :current
#
# set :user,            "deployer"
# set :group,           "staff"
# set :use_sudo,        false
#
# role :web,    %w{niobe}
# role :app,    %w{niobe}
# role :db,     %w{niobe}, primary: true
#
# set(:latest_release)  { fetch(:current_path) }
# set(:release_path)    { fetch(:current_path) }
# set(:current_release) { fetch(:current_path) }
#
# set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
# set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
# set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }
#
# namespace :deploy do
#   desc "Deploy your application"
#   task :default do
#     update
#     restart
#   end
#
#   desc "Setup your git-based deployment app"
#   task :setup, except: { no_release: true } do
#     dirs = [deploy_to, shared_path]
#     dirs += shared_children.map { |d| File.join(shared_path, d) }
#     run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
#     run "git clone #{repository} #{current_path}"
#   end
#
#   task :cold do
#     update
#     migrate
#   end
#
#   task :update do
#     transaction do
#       update_code
#     end
#   end
#
#   desc "Update the deployed code."
#   task :update_code, except: { no_release: true } do
#     run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
#     finalize_update
#   end
#
#   desc "Update the database (overwritten to avoid symlink)"
#   task :migrations do
#     transaction do
#       update_code
#     end
#     migrate
#     restart
#   end
#
#   task :finalize_update, except: { no_release: true } do
#     run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)
#
#     # mkdir -p is making sure that the directories are there for some SCM's that don't
#     # save empty folders
#     run <<-CMD
#       rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp/pids &&
#       mkdir -p #{latest_release}/public &&
#       mkdir -p #{latest_release}/tmp &&
#       ln -s #{shared_path}/log #{latest_release}/log &&
#       ln -s #{shared_path}/system #{latest_release}/public/system &&
#       ln -s #{shared_path}/pids #{latest_release}/tmp/pids &&
#       ln -sf #{shared_path}/config/database.yml #{latest_release}/config/database.yml
#     CMD
#
#     #precompile the assets
#     run "cd #{latest_release}; bundle exec rake assets:precompile"
#
#     if fetch(:normalize_asset_timestamps, true)
#       stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
#       asset_paths = fetch(:public_children, %w(images stylesheets javascripts)).map { |p| "#{latest_release}/public/#{p}" }.join(" ")
#       run "find #{asset_paths} -exec touch -t #{stamp} {} ';'; true", env: { "TZ" => "UTC" }
#     end
#   end
#
#   desc "Zero-downtime restart of Unicorn"
#   task :restart, except: { no_release: true } do
#     run "kill -s USR2 `cat /tmp/unicorn.comman.pid`"
#   end
#
#   desc "Start unicorn"
#   task :start, except: { no_release: true } do
#     run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
#   end
#
#   desc "Stop unicorn"
#   task :stop, except: { no_release: true } do
#     run "kill -s QUIT `cat /tmp/unicorn.comman.pid`"
#   end
#
#   namespace :rollback do
#     desc "Moves the repo back to the previous version of HEAD"
#     task :repo, except: { no_release: true } do
#       set :branch, "HEAD@{1}"
#       deploy.default
#     end
#
#     desc "Rewrite reflog so HEAD@{1} will continue to point to at the next previous release."
#     task :cleanup, except: { no_release: true } do
#       run "cd #{current_path}; git reflog delete --rewrite HEAD@{1}; git reflog delete --rewrite HEAD@{1}"
#     end
#
#     desc "Rolls back to the previously deployed version."
#     task :default do
#       rollback.repo
#       rollback.cleanup
#     end
#   end
# end
#
# def run_rake(cmd)
#   run "cd #{current_path}; #{rake} #{cmd}"
# end

# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
