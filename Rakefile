require 'rake/clean'

if ENV.key?('CRYSTAL_BIN')
  _crystal_path = `./crystal env | grep CRYSTAL_PATH | cut -d'"' -f2`
  CRYSTAL_BIN = "CRYSTAL_PATH=\"#{_crystal_path}:lib\" #{ENV['CRYSTAL_BIN']}"
else
  CRYSTAL_BIN = 'crystal'
end

CLEAN.include 'coverage'
CLEAN.include '*.tmp'
CLEAN.include '*.dwarf'

task :default => :spec

desc "build"
task :build do
  puts "Current CRYSTAL_BIN is #{CRYSTAL_BIN}"
  system "#{CRYSTAL_BIN} build src/froprepro.cr"
end

desc "run"
task :run do
  system "#{CRYSTAL_BIN} run src/froprepro.cr"
end

desc "spec"
task :spec do
  system "./bin/crystal-coverage spec/spec_all.cr"
end
