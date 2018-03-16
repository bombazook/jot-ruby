require "bundler/gem_tasks"
require "rspec/core/rake_task"

namespace :build do
  task :webpack do
    system('yarn exec webpack')
  end
end

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
