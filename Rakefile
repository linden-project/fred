require 'rake/clean'

PRODUCT_NAME="fred"

if ENV.key?('CRYSTAL_BIN')
  _crystal_path = `#{ENV['CRYSTAL_BIN']} env | grep CRYSTAL_PATH | cut -d'"' -f2`.gsub("\n",'')
  CRYSTAL_BIN = 'CRYSTAL_PATH="' + _crystal_path + ':lib" ' + ENV['CRYSTAL_BIN']
else
  CRYSTAL_BIN = 'crystal'
end

CLEAN.include 'coverage'
CLEAN.include 'docs'
CLEAN.include '*.tmp'
CLEAN.include '*.dwarf'
CLEAN.include PRODUCT_NAME

task :default => :spec

desc "build"
task :build do
  puts "Current CRYSTAL_BIN is #{CRYSTAL_BIN}"
  system "#{CRYSTAL_BIN} build src/#{PRODUCT_NAME}.cr"
end

desc "run"
task :run do
  puts "you should execute: #{CRYSTAL_BIN} run src/#{PRODUCT_NAME}.cr"
end

desc "release"
task :release do
  puts "you should execute: crelease x.x.x"
end

desc "spec"
task :spec do
  system "#{CRYSTAL_BIN} spec"
end

desc "coverage"
task :coverage do
  system "./bin/crystal-coverage spec/spec_all.cr"
end
