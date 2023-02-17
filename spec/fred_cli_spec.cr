require "./spec_helper"

describe Fred do
  #  it "should test command line rename_front_matter_key" do
  #
  #    tempfile = temp_filename
  #    FileUtils.cp "./spec/testfiles/markdown_2.md", tempfile
  #
  #    command = "/usr/local/bin/crystal run ./src/fred.cr rename_front_matter_key key1 key13new " + tempfile
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
