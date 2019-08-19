require 'rake/clean'
CLEAN.include 'coverage'

task :default => :spec

desc "build"
task :build do
  system "crystal build src/froprepro.cr"
end

desc "run"
task :run do
  system "crystal run src/froprepro.cr"
end

desc "spec"
task :spec do
  system "./bin/crystal-coverage spec/froprepro_spec.cr"
end
