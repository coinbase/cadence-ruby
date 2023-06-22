require 'rubygems'
require 'bundler/setup'

Bundler.require

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

desc 'All cucumber features with kitchen sink appraisal'
task :cucumber do
  system('appraisal kitchen-sink cucumber -f progress --publish-quiet')
end

default_task = ENV['APPRAISAL_INITIALIZED'] ? :spec : %i[cucumber appraisal]

task default: default_task
