#!/usr/bin/env rake
require "bundler/gem_tasks"

desc 'Run all tests'
task :test_all => :generate_test_data do
	$: << './lib' << './test'
	require 'backwardsfile.rb'
	require 'all_tests.rb'
end

task :pry => :generate_test_data do
	$: << './lib'
	require 'pry'
	require 'backwardsfile.rb'
	Dir.chdir 'test/tmp'
	binding.pry
	Dir.chdir '../..'
end

task :generate_test_data do
	TEST_DATA = (1..4).map { |i| "Test file line #{i}." }
	File.open('test/tmp/testfile_lf.txt','w+') { |f| f.write TEST_DATA.join("\n") }
	File.open('test/tmp/testfile_crlf.txt', 'w+') { |f| f.write TEST_DATA.join("\r\n") }
	File.open('test/tmp/testfile_q.txt','w+') { |f| f.write TEST_DATA.join("q") } 
end
