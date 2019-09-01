require 'rake/clean'

PRODUCT_NAME="froprepro"

if ENV.key?('CRYSTAL_BIN')
  _crystal_path = `#{ENV['CRYSTAL_BIN']} env | grep CRYSTAL_PATH | cut -d'"' -f2`.gsub("\n",'')
  CRYSTAL_BIN = 'CRYSTAL_PATH="' + _crystal_path + ':lib" ' + ENV['CRYSTAL_BIN']
else
  CRYSTAL_BIN = 'crystal'
end

CLEAN.include 'coverage'
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
  system "#{CRYSTAL_BIN} run src/#{PRODUCT_NAME}.cr"
end

desc "spec"
task :spec do
  system "#{CRYSTAL_BIN} spec"
end

desc "coverage"
task :coverage do
  system "./bin/crystal-coverage spec/spec_all.cr"
end
