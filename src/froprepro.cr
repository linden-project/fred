require "clim"
require "front_matter"
require "yaml"
require "./froprepro/*"

module Froprepro

  class Cli < Clim

    main do
      desc "help"
      usage "froprepro help"
      run do |opts, args|
        puts opts.help_string
      end

      sub "version" do
        desc "version"
        usage "froprepro version"
        run do |opts, args|
          puts Froprepro::VERSION
        end
      end

      sub "proc" do
        desc "process front matter"
        usage "froprepro proc [MARKDOWN FILE]"
        run do |opts, args|

          if args.size == 1
            infile = File.expand_path(args[0])

            if File.file?(infile)
              markdown_doc = MarkdownDoc.new(infile)
              markdown_doc.replace_1st_level_frontmatter_variables
              print markdown_doc.dump_markdown
            end

          end
        end
      end

      sub "rename_taxo_key_in_file" do
        desc "rename a taxo string val"
        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        usage "froprepro rename_taxo_key_in_file [taxo_key_old] [taxo_key_new] [MARKDOWN FILE]"
        run do |opts, args|
          if args.size == 3
            fs_processor = FSProcessor.new(opts.dryrun)
            fs_processor.rename_taxo_key_in_file(args[2], args[0], args[1])
          else
            puts opts.help_string
          end
        end
      end

      sub "rename_taxo_val_in_file" do
        desc "rename a taxo string val"
        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        usage "froprepro rename_taxo_val_in_file [taxo_key] [taxo_val_old] [taxo_val_new] [MARKDOWN FILE]"
        run do |opts, args|
          if args.size == 4
            fs_processor = FSProcessor.new(opts.dryrun)
            fs_processor.rename_taxo_val_in_file(args[3], args[0], args[1], args[2])
          else
            puts opts.help_string
          end
        end
      end

    end


  end

end

Froprepro::Cli.start(ARGV)
