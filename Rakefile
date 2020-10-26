# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task default: :test

Rake::Task['release'].enhance do
  puts "Don't forget to publish the release on GitHub!"
  system 'open https://github.com/adamzapasnik/rubocop_config_updater/releases'
end
