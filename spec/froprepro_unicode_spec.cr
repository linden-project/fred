require "./spec_helper"
p "unicode"
def temp_filename
  Random::Secure.urlsafe_base64(4) + ".tmp"
end

describe Froprepro do

  it "should print VERSION" do
    puts Froprepro::VERSION
  end

  it "should rename tax val to special char" do
    dryrun = false
    recursive = false
    verbose = false

    tempfile = temp_filename
    FileUtils.cp "./spec/testfiles/markdown_2.md", tempfile
    fs_processor = FSProcessor.new(tempfile, dryrun, recursive, verbose)
    fs_processor.rename_taxo_val( "key1", "val_old", "©")

    content_new = File.read(tempfile)
    content_new.includes?("©").should eq(true)
    FileUtils.rm(tempfile)
  end

  it "should rename tax val with a special char" do
    dryrun = false
    recursive = false
    verbose = false

    tempfile = temp_filename
    FileUtils.cp "./spec/testfiles/markdown_2.md", tempfile
    fs_processor = FSProcessor.new(tempfile, dryrun, recursive, verbose)
    fs_processor.rename_taxo_val( "key2", "üòmlaubt", "bar")

    content_new = File.read(tempfile)
    content_new.includes?("bar").should eq(true)
    FileUtils.rm(tempfile)
  end

  it "should rename tax vals with all regular special chars 1" do
    dryrun = false
    recursive = false
    verbose = false

    tempfile = temp_filename
    FileUtils.cp "./spec/testfiles/markdown_utf.md", tempfile
    fs_processor = FSProcessor.new(tempfile, dryrun, recursive, verbose)
    fs_processor.rename_taxo_val( "got_some", "éèëê ûüú ïî âáäà óòöô ç ©", "foo")

    content_new = File.read(tempfile)
    content_new.includes?("foo").should eq(true)
    FileUtils.rm(tempfile)
  end

  it "should rename tax vals with all regular special chars 2" do
    dryrun = false
    recursive = false
    verbose = false

    tempfile = temp_filename
    FileUtils.cp "./spec/testfiles/markdown_utf.md", tempfile
    fs_processor = FSProcessor.new(tempfile, dryrun, recursive, verbose)
    fs_processor.rename_taxo_val( "got_it_all", "éèëê ûüú ïî âáäà óòöô ç © &@$€", "bar")

    content_new = File.read(tempfile)
    content_new.includes?("bar").should eq(true)
    FileUtils.rm(tempfile)
  end

  it "should rename tax vals with to special chars 3" do
    dryrun = false
    recursive = false
    verbose = false

    tempfile = temp_filename
    FileUtils.cp "./spec/testfiles/markdown_utf2.md", tempfile
    fs_processor = FSProcessor.new(tempfile, dryrun, recursive, verbose)
    fs_processor.rename_taxo_val( "has_it_all", "jojo", "éèëê ûüú")

    content_new = File.read(tempfile)
    p content_new
    content_new.includes?("éèëê ûüú").should eq(true)
    FileUtils.rm(tempfile)
  end

end
