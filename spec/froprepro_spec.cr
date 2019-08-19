require "./spec_helper"

describe Froprepro do

  it "should rename tax val in a single file" do

    tempfile = Random::Secure.urlsafe_base64(4)
    FileUtils.cp "./spec/testfiles/markdown_2.md", tempfile

    dryrun = false
    recursive = false
    fs_processor = FSProcessor.new(dryrun, recursive)
    fs_processor.rename_taxo_val(tempfile, "key1", "val_old", "val_new")

#    FileUtils.rm(tempfile)
    #    false.should eq(true)
  end

  it "should write to file" do
    dryrun = false
    recursive = false

    tempfile = Random::Secure.urlsafe_base64(4)
    contents = "some content\n"
    fs_processor = FSProcessor.new(dryrun, recursive)
    fs_processor.write_to_file(tempfile, contents)

    file_content = File.read(tempfile)
    file_content.should eq(contents)
    FileUtils.rm(tempfile)
  end
end
