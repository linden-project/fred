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


      sub "set_bool_val" do
        desc "Set boolean value for front matter key"

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
          desc: "true or false",
          type: Bool,
          required: true

        usage "fred set_bool_val [PATH] [FRONT_MATTER_KEY] [true / false] [options]"

        run do |opts, args|
          path = args.path

          fs_processor = FSProcessor.new(path, opts.dryrun, opts.recursive, opts.verbose)
          fs_processor.set_key_val(args.front_matter_key, args.front_matter_val)
        end
      end

      sub "set_string_val" do
        desc "Set string value for front matter key"

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
          desc: "string value to set",
          type: String,
          required: true

        usage "fred set_string_val [PATH] [KEY] [VAL] [options]"

        run do |opts, args|
          path = args.path
          fs_processor = FSProcessor.new(path, opts.dryrun, opts.recursive, opts.verbose)
          fs_processor.set_key_val(args.front_matter_key, args.front_matter_val)
        end
      end

      sub "unset_key" do
        desc "Remove key from front matter"

        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        option "-r", "--recursive", type: Bool, desc: "Path is a directory. All .md files in the directory will be processed"
        option "-v", "--verbose", type: Bool, desc: "Be verbose"

        argument "path",
          desc: "directory or file",
          type: String,
          required: true

        argument "unset_key",
          desc: "key to remove",
          type: String,
          required: true

        usage "fred unset_key [PATH] [KEY] [options]"

        run do |opts, args|
          path = args.path
          fs_processor = FSProcessor.new(path, opts.dryrun, opts.recursive, opts.verbose)
          fs_processor.unset_front_matter_key(args.unset_key)
        end
      end

      sub "replace_key" do
        desc "Find and replace key in front matter"

        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        option "-r", "--recursive", type: Bool, desc: "Path is a directory. All .md files in the directory will be processed"
        option "-v", "--verbose", type: Bool, desc: "Be verbose"

        argument "path",
          desc: "directory or file",
          type: String,
          required: true

        argument "key_old",
          desc: "key to replace",
          type: String,
          required: true

        argument "key_new",
          desc: "new key",
          type: String,
          required: true

        usage "fred replace_key [PATH] [KEY_OLD] [KEY_NEW] [options]"

        run do |opts, args|
          path = args.path
          fs_processor = FSProcessor.new(path, opts.dryrun, opts.recursive, opts.verbose)
          fs_processor.rename_front_matter_key(args.key_old, args.key_new)
        end
      end

      sub "replace_string_val" do
        desc "Find and replace a string value in front matter"

        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        option "-r", "--recursive", type: Bool, desc: "Path is a directory. All .md files in the directory will be processed"
        option "-v", "--verbose", type: Bool, desc: "Be verbose"

        argument "path",
          desc: "directory or file",
          type: String,
          required: true

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

        usage "fred replace_string_val [PATH] [KEY] [VAL_OLD] [VAL_NEW] [options]"

        run do |opts, args|
          fs_processor = FSProcessor.new(args.path, opts.dryrun, opts.recursive, opts.verbose)
          fs_processor.rename_front_matter_val(args.front_matter_key, args.front_matter_val_old, args.front_matter_val_new)
        end
      end

      sub "toggle_bool_val" do
        desc "Toggle a bool value in front matter, if true set false, if false or missing set true"

        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        option "-r", "--recursive", type: Bool, desc: "Path is a directory. All .md files in the directory will be processed"
        option "-v", "--verbose", type: Bool, desc: "Be verbose"

        argument "path",
          desc: "directory or file",
          type: String,
          required: true

        argument "front_matter_key",
          desc: "key to toggle value for",
          type: String,
          required: true

        usage "fred toggle_bool_val [PATH] [KEY] [options]"

        run do |opts, args|
          fs_processor = FSProcessor.new(args.path, opts.dryrun, opts.recursive, opts.verbose)
          fs_processor.toggle_bool_val(args.front_matter_key)
        end
      end

      sub "replace_1st_level_vars" do
        desc "replace variables found on 1st level in other levels in inside front matter"

        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        option "-r", "--recursive", type: Bool, desc: "Path is a directory. All .md files in the directory will be processed"
        option "-v", "--verbose", type: Bool, desc: "Be verbose"

        argument "path",
          desc: "directory or file",
          type: String,
          required: true

        usage "fred replace_1st_level_vars [PATH] [options]"

        run do |opts, args|
          path = args.path
          fs_processor = FSProcessor.new(path, opts.dryrun, opts.recursive, opts.verbose)
          fs_processor.replace_1st_level_vars
        end
      end

      sub "replace_includes" do
        desc "replace includes inside front matter"

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

      sub "process_functions" do
        desc "replace $FORMAT and $INCLUDE inside front matter"

        option "-d", "--dryrun", type: Bool, desc: "Dry run. Output only"
        option "-r", "--recursive", type: Bool, desc: "Path is a directory. All .md files in the directory will be processed"
        option "-v", "--verbose", type: Bool, desc: "Be verbose"

        argument "path",
          desc: "directory or file",
          type: String,
          required: true

        usage "fred process_functions [PATH] [options]"
        run do |opts, args|
          path = args.path
          fs_processor = FSProcessor.new(path, opts.dryrun, opts.recursive, opts.verbose)
          fs_processor.process_all_specials
        end
      end


      sub "version" do
        desc "version"
        usage "fred version"
        run do |opts, args|
          puts Fred::VERSION
        end
      end

    end
  end
end

{% if !@type.has_constant? "TESTING" %}
  Fred::Cli.start(ARGV)
{% end %}
