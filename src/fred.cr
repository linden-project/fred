require "clim"
require "front_matter"
require "yaml"
require "./fred/*"

WORKAROUND_YAML_UNICODE_BUG = true

module Fred
  class Cli < Clim
    main do
      desc "help"
      usage "fred help"
      run do |opts, args|
        puts opts.help_string
      end

      sub "version" do
        desc "version"
        usage "fred version"
        run do |opts, args|
          puts Fred::VERSION
        end
      end

      sub "echo" do
        desc "echo display one node by key"


        argument "file",
          desc: "markdown file",
          type: String,
          required: true
        argument "key",
          desc: "key to display",
          type: String,
          required: true

        usage "fred echo [key] [file]"
        run do |opts, args|
          path = args.file
          markdown_doc = MarkdownDoc.new(path, true)
          print markdown_doc.front_matter_as_yaml[args.key]
        end
      end

      sub "process_frontmatter_specials" do
        desc "replace $FORMAT and $INCLUDE inside the front matter"

        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        option "-r", "--recursive", type: Bool, desc: "Path is a directory. All .md files in the directory will be processed"
        option "-v", "--verbose", type: Bool, desc: "Be verbose"

        argument "path",
          desc: "directory or file",
          type: String,
          required: true

        usage "fred process_frontmatter_specials [PATH]"
        run do |opts, args|
          path = args.path
          fs_processor = FSProcessor.new(path, opts.dryrun, opts.recursive, opts.verbose)
          fs_processor.process_all_specials
        end
      end

      sub "replace_1st_level_vars" do
        desc "replace 1st level variables in inside the front matter"

        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        option "-r", "--recursive", type: Bool, desc: "Path is a directory. All .md files in the directory will be processed"
        option "-v", "--verbose", type: Bool, desc: "Be verbose"

        argument "path",
          desc: "directory or file",
          type: String,
          required: true

        usage "fred replace_1st_level_vars [PATH]"

        run do |opts, args|
          path = args.path
          fs_processor = FSProcessor.new(path, opts.dryrun, opts.recursive, opts.verbose)
          fs_processor.replace_1st_level_vars
        end
      end

      sub "replace_includes" do
        desc "replace includes inside the front matter"

        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        option "-r", "--recursive", type: Bool, desc: "Path is a directory. All .md files in the directory will be processed"
        option "-v", "--verbose", type: Bool, desc: "Be verbose"

        argument "path",
          desc: "directory or file",
          type: String,
          required: true

        usage "fred replace_includes [PATH] [options]"
        run do |opts, args|
          path = args.path
          fs_processor = FSProcessor.new(path, opts.dryrun, opts.recursive, opts.verbose)
          fs_processor.replace_includes
        end
      end

      sub "rename_taxo_key" do
        desc "rename a taxo string val"

        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        option "-r", "--recursive", type: Bool, desc: "Path is a directory. All .md files in the directory will be processed"
        option "-v", "--verbose", type: Bool, desc: "Be verbose"

        argument "taxo_key_old",
          desc: "key to replace",
          type: String,
          required: true
        argument "taxo_key_new",
          desc: "new key",
          type: String,
          required: true
        argument "path",
          desc: "directory or file",
          type: String,
          required: true

        usage "fred rename_taxo_key [taxo_key_old] [taxo_key_new] [PATH]"

        run do |opts, args|
          path = args.path
          fs_processor = FSProcessor.new(path, opts.dryrun, opts.recursive, opts.verbose)
          fs_processor.rename_taxo_key(args.taxo_key_old, args.taxo_key_new)
        end
      end

      sub "rename_taxo_val" do
        desc "rename a taxo string val in a single file"

        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        option "-r", "--recursive", type: Bool, desc: "Path is a directory. All .md files in the directory will be processed"
        option "-v", "--verbose", type: Bool, desc: "Be verbose"

        argument "taxo_key",
          desc: "key to replace value for",
          type: String,
          required: true
        argument "taxo_val_old",
          desc: "old value",
          type: String,
          required: true
        argument "taxo_val_new",
          desc: "new value",
          type: String,
          required: true
        argument "path",
          desc: "directory or file",
          type: String,
          required: true

        usage "fred rename_taxo_val [taxo_key] [taxo_val_old] [taxo_val_new] [PATH]"

        run do |opts, args|
          fs_processor = FSProcessor.new(args.path, opts.dryrun, opts.recursive, opts.verbose)
          fs_processor.rename_taxo_val(args.taxo_key, args.taxo_val_old, args.taxo_val_new)
        end
      end
    end
  end
end

{% if !@type.has_constant? "TESTING" %}
  Fred::Cli.start(ARGV)
{% end %}
