require 'rake/clean'

PRODUCT_NAME="fred"

if ENV.key?('CRYSTAL_BIN')
  _crystal_path = `#{ENV['CRYSTAL_BIN']} env | grep CRYSTAL_PATH | cut -d'"' -f2`.gsub("\n",'')
  CRYSTAL_BIN = 'CRYSTAL_PATH="' + _crystal_path + ':lib" ' + ENV['CRYSTAL_BIN']
else
  CRYSTAL_BIN = 'crystal'
end

task :default => :build

desc "build"
task :build do
  puts "Current CRYSTAL_BIN is #{CRYSTAL_BIN}"
  system "#{CRYSTAL_BIN} build src/#{PRODUCT_NAME}.cr"
end

desc "release"
task :release do
  puts "you should execute: crelease x.x.x"
end
