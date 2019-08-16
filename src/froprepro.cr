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

    end
  end
end

Froprepro::Cli.start(ARGV)
