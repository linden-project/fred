require "./spec_helper"

describe Fred do
  it "should print VERSION" do
    puts Fred::VERSION
  end

  it "should rename tax key and vals in a single file" do
    dryrun = false
    recursive = false
    verbose = false

    tempfile = temp_filename
    FileUtils.cp "./spec/testfiles/markdown_2.md", tempfile
    fs_processor = FSProcessor.new(tempfile, dryrun, recursive, verbose)
    fs_processor.rename_front_matter_val("key1", "val_old", "val_new")
    fs_processor.rename_front_matter_key("key2", "key2new")

    content_new = File.read(tempfile)
    content_new.includes?("val_new").should eq(true)
    FileUtils.rm(tempfile)
  end

  it "should rename tax key and vals in a directory" do
    tempfile = temp_filename

    FileUtils.cp_r "./spec/testfiles", tempfile

    dryrun = false
    recursive = true
    verbose = false

    fs_processor = FSProcessor.new(tempfile, dryrun, recursive, verbose)
    fs_processor.rename_front_matter_val("key1", "val_old", "val_new")

    content_new = File.read(tempfile + "/markdown_2.md")
    content_new.includes?("val_new").should eq(true)

    FileUtils.rm_r(tempfile)
  end

  it "should NOT rename tax key and vals when dryrun = true" do
    tempfile = temp_filename

    FileUtils.cp_r "./spec/testfiles", tempfile

    dryrun = true
    recursive = true
    verbose = false

    fs_processor = FSProcessor.new(tempfile, dryrun, recursive, verbose)
    fs_processor.rename_front_matter_val("key1", "val_old", "val_new")
    fs_processor.rename_front_matter_key("key2", "key2new")

    content_new = File.read(tempfile + "/markdown_2.md")
    content_new.includes?("val_new").should eq(false)
    content_new.includes?("key2new").should eq(false)
    FileUtils.rm_r(tempfile)
  end

  it "should replace variables on inside values that contain $FORMAT" do
    tempfile = temp_filename

    FileUtils.cp_r "./spec/testfiles", tempfile

    dryrun = false
    recursive = true
    verbose = false

    fs_processor = FSProcessor.new(tempfile, dryrun, recursive, verbose)
    fs_processor.replace_1st_level_vars

    content_new = File.read(tempfile + "/markdown_4.md")
    content_new.includes?("  key3.1: This file was written by Mad John.").should eq(true)
    content_new.includes?("key4: yeah baby!").should eq(true)
    content_new.split("---").size.should eq(3)

    FileUtils.rm_r(tempfile)
  end
end
