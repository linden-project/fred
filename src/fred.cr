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

      sub "set_key_val" do
        desc "Set key and value in the root Front Matter"

        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        option "-r", "--recursive", type: Bool, desc: "Path is a directory. All .md files in the directory will be processed"
        option "-v", "--verbose", type: Bool, desc: "Be verbose"

        argument "path",
          desc: "directory or file",
          type: String,
          required: true
        argument "front_matter_key",
          desc: "key to set",
          type: String,
          required: true
        argument "front_matter_val",
          desc: "value for the key",
          type: String,
          required: true

        usage "fred set_key_val [PATH] [FRONT_MATTER_KEY] [FRONT_MATTER_VAL]"

        run do |opts, args|
          path = args.path
          fs_processor = FSProcessor.new(path, opts.dryrun, opts.recursive, opts.verbose)
          fs_processor.set_key_val(args.front_matter_key, args.front_matter_val)
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

      sub "rename_front_matter_key" do
        desc "Rename a Front Matter key"

        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        option "-r", "--recursive", type: Bool, desc: "Path is a directory. All .md files in the directory will be processed"
        option "-v", "--verbose", type: Bool, desc: "Be verbose"

        argument "front_matter_key_old",
          desc: "key to replace",
          type: String,
          required: true
        argument "front_matter_key_new",
          desc: "new key",
          type: String,
          required: true
        argument "path",
          desc: "directory or file",
          type: String,
          required: true

        usage "fred rename_front_matter_key [front_matter_key_old] [front_matter_key_new] [PATH]"

        run do |opts, args|
          path = args.path
          fs_processor = FSProcessor.new(path, opts.dryrun, opts.recursive, opts.verbose)
          fs_processor.rename_front_matter_key(args.front_matter_key_old, args.front_matter_key_new)
        end
      end

      sub "rename_front_matter_val" do
        desc "Rename a Front Matter string value in a single file"

        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        option "-r", "--recursive", type: Bool, desc: "Path is a directory. All .md files in the directory will be processed"
        option "-v", "--verbose", type: Bool, desc: "Be verbose"

        argument "front_matter_key",
          desc: "key to replace value for",
          type: String,
          required: true
        argument "front_matter_val_old",
          desc: "old value",
          type: String,
          required: true
        argument "front_matter_val_new",
          desc: "new value",
          type: String,
          required: true
        argument "path",
          desc: "directory or file",
          type: String,
          required: true

        usage "fred rename_front_matter_val [front_matter_key] [front_matter_val_old] [front_matter_val_new] [PATH]"

        run do |opts, args|
          fs_processor = FSProcessor.new(args.path, opts.dryrun, opts.recursive, opts.verbose)
          fs_processor.rename_front_matter_val(args.front_matter_key, args.front_matter_val_old, args.front_matter_val_new)
        end
      end
    end
  end
end

{% if !@type.has_constant? "TESTING" %}
  Fred::Cli.start(ARGV)
{% end %}
