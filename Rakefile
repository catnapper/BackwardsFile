#!/usr/bin/env rake
require "bundler/gem_tasks"

task :default => :all_tests

desc 'Run all tests'
task :all_tests do
  $: << './lib' << './test'
  require 'backwardsfile.rb'
  require 'all_tests.rb'
end
