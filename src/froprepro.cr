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

      sub "rename_taxo_key" do
        desc "rename a taxo string val"
        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        option "-r", "--recursive", type: Bool, desc: "Path is a directory. All .md files in the directory will be processed"
        option "-v", "--verbose", type: Bool, desc: "Be verbose"
        usage "froprepro rename_taxo_key [taxo_key_old] [taxo_key_new] [PATH]"

        run do |opts, args|

         if args.size == 3
           fs_processor = FSProcessor.new(opts.dryrun, opts.recursive, opts.verbose)
           fs_processor.rename_taxo_key(args[2], args[0], args[1])
         else
           puts opts.help_string
         end

        end
      end

      sub "rename_taxo_val" do
        desc "rename a taxo string val in a single file"
        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        option "-r", "--recursive", type: Bool, desc: "Path is a directory. All .md files in the directory will be processed"
        option "-v", "--verbose", type: Bool, desc: "Be verbose"
        usage "froprepro rename_taxo_val [taxo_key] [taxo_val_old] [taxo_val_new] [PATH]"

        run do |opts, args|
          if args.size == 4
            fs_processor = FSProcessor.new(opts.dryrun, opts.recursive, opts.verbose)
            fs_processor.rename_taxo_val(args[3], args[0], args[1], args[2])
          else
            puts opts.help_string
          end
        end

      end
    end
  end
end

{% if ! @type.has_constant? "TESTING" %}
  Froprepro::Cli.start(ARGV)
{% end %}
