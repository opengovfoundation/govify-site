#
# Put here shared configuration shared among all children
#
# Read more about configurations:
# https://github.com/railsware/capistrano-multiconfig/README.md

# Configuration example for layout like:
# config/deploy/{NAMESPACE}/.../#{PROJECT_NAME}/{STAGE_NAME}.rb

set :scm, :git

set :git_shallow_clone, 1

set :deploy_via, :export

#set :branch, lambda { Capistrano::CLI.ui.ask "SCM branch: " }
set :branch, ENV['BRANCH'] || "master"

#set(:application) { config_name.split(':').reverse[1] }

set :application, 'govify.org'

set(:site) { config_name.split(':')[0] }

set(:stage) { config_name.split(':').last }

set(:rake) { use_bundle ? "bundle exec rake" : "rake" }

set :repository,  "git@github.com:opengovfoundation/govify-site.git"

set :user, "deploy"
set :group, "staff"
set :use_sudo, false

set(:deploy_to) { "/var/www/releases/#{application}/#{site}/#{stage}" }

# Delete all of the old releases please!
set :keep_releases, 3
after "deploy:update", "deploy:cleanup"

# Don't do the normal timestamp update, as it uses Rails paths.
set :normalize_asset_timestamps, false

# We're not using any of the other shared folders atm, so remove them.
set :shared_children, []

# set :calendar_username, 'vasya.pupkin@gmail.com'
#
# set :calendar_password, 'qwery123456'
#
# set(:calendar_name) { "mycompany-#{stage}" }
#
# after 'deploy' do
#   set :calendar_event_title, "[DEPLOYED] #{application} #{branch}: #{real_revision}"
#   top.calendar.create_event
# end

after "deploy:finalize_update" do
#  run "ln -nfs #{shared_path}/includes/wp-config.php #{release_path}/wp-config.php"
#  run "ln -nfs #{shared_path}/data/uploads #{release_path}/wp-content/uploads"
end

# Setup the shared folders.  Since we don't symlink these directly,
# we can't just throw them in :shared_children.
after "deploy:setup" do
  run "mkdir -p #{shared_path}/data/uploads"
  run "chmod -R g+rw #{shared_path}/uploads"
  run "mkdir #{shared_path}/includes"
  run "chmod g+rw #{shared_path}/includes"
end

