require "./spec_helper"
p "cli"

def temp_filename
  Random::Secure.urlsafe_base64(4) + ".tmp"
end

describe Fred do
  #  it "should test command line rename_taxo_key" do
  #
  #    tempfile = temp_filename
  #    FileUtils.cp "./spec/testfiles/markdown_2.md", tempfile
  #
  #    command = "/usr/local/bin/crystal run ./src/fred.cr rename_taxo_key key1 key13new " + tempfile
  #    #io = IO::Memory.new
  #
  #    cmd = "sh"
  #    args = [] of String
  #    args << "-c" << command
  #    Process.run(cmd, args)
  #
  #    #Process.run(command, shell: true, output: io)
  #
  #    #output = io.to_s
  #    #output.should eq("jojo")
  #
  #    content_new = File.read(tempfile)
  #    #content_new.includes?("val_new").should eq(false)
  #    content_new.includes?("key13new").should eq(true)
  #
  #  end
end
