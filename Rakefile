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

desc "update and copy and git push brew_formula"
task :brew_formula do

  require 'yaml'
  require 'erb'

  shard = YAML.load_file('shard.yml')

  system("cd /tmp && wget https://github.com/mipmip/fred/archive/v#{shard['version']}.tar.gz")
  sha = `shasum --algorithm 256 /tmp/v#{shard['version']}.tar.gz|cut -d" " -f1`.gsub("\n","")

  template = File.read('brew/fred.rb.erb')
  namespace = OpenStruct.new(
    sha: sha,
    desc: shard['desc'],
    version: shard['version']
  )

  result = ERB.new(template).result(namespace.instance_eval { binding })
  File.open("/Users/pim/RnD/homebrew-crystal/fred.rb", 'w') { |file| file.write(result)}

  system("cd ~/RnD/homebrew-crystal && git commit -m 'Fred release #{shard['version']}' -a && git push")

end
