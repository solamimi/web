# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks
desc 'Migration After task'
task :i18n do
  puts 'generate i18n'
  puts `bundle exec rails g i18n_translation ja -f`
end

Rake::Task['db:migrate'].enhance do
  Rake::Task['i18n'].invoke
end
