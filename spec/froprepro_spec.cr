require "./spec_helper"

def temp_filename
  Random::Secure.urlsafe_base64(4) + ".tmp"
end

describe Froprepro do

  it "should print VERSION" do
    puts Froprepro::VERSION
  end

  it "should rename tax key and vals in a single file" do
    tempfile = temp_filename
    FileUtils.cp "./spec/testfiles/markdown_2.md", tempfile

    dryrun = false
    recursive = false
    verbose = true

    fs_processor = FSProcessor.new(dryrun, recursive, verbose)
    fs_processor.rename_taxo_val(tempfile, "key1", "val_old", "val_new")
    fs_processor.rename_taxo_key(tempfile, "key2", "key2new")

    content_new = File.read(tempfile)
    content_new.includes?("val_new").should eq(true)
    content_new.includes?("key2new").should eq(true)
    FileUtils.rm(tempfile)
  end

  it "should rename tax key and vals in a directory" do
    tempfile = temp_filename

    FileUtils.cp_r "./spec/testfiles", tempfile

    dryrun = false
    recursive = true
    verbose = false

    fs_processor = FSProcessor.new(dryrun, recursive, verbose)
    fs_processor.rename_taxo_val(tempfile, "key1", "val_old", "val_new")
    fs_processor.rename_taxo_key(tempfile, "key2", "key2new")

    content_new = File.read(tempfile + "/markdown_2.md")
    content_new.includes?("val_new").should eq(true)
    content_new.includes?("key2new").should eq(true)

    FileUtils.rm_r(tempfile)
  end

  it "should NOT rename tax key and vals in a directory" do
    tempfile = temp_filename

    FileUtils.cp_r "./spec/testfiles", tempfile

    dryrun = true
    recursive = true
    verbose = false

    fs_processor = FSProcessor.new(dryrun, recursive, verbose)
    fs_processor.rename_taxo_val(tempfile, "key1", "val_old", "val_new")
    fs_processor.rename_taxo_key(tempfile, "key2", "key2new")

    content_new = File.read(tempfile + "/markdown_2.md")
    content_new.includes?("val_new").should eq(false)
    content_new.includes?("key2new").should eq(false)
    FileUtils.rm_r(tempfile)
  end

  it "should write to file" do
    dryrun = false
    recursive = false
    verbose = false

    tempfile = temp_filename
    contents = "some content\n"
    fs_processor = FSProcessor.new(dryrun, recursive, verbose)
    fs_processor.write_to_file(tempfile, contents)

    file_content = File.read(tempfile)
    file_content.should eq(contents)
    FileUtils.rm(tempfile)
  end

#  it "should test command line rename_taxo_key" do
#
#    tempfile = temp_filename
#    FileUtils.cp "./spec/testfiles/markdown_2.md", tempfile
#
#    command = "/usr/local/bin/crystal run ./src/froprepro.cr rename_taxo_key key1 key13new " + tempfile
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
