class MarkdownDoc
  getter changed
  getter front_matter_as_yaml

  def initialize(infile : String, only_output_when_changed : Bool)
    @only_output_when_changed = false
    @only_output_when_changed = only_output_when_changed

    @document_body = String.new
    @front_matter_as_yaml = YAML.parse "{}"
    @document_body = File.read(infile)

    if File.read_lines(infile)[0..1][0] == "---"
      FrontMatter.open(infile, false) do |front_matter, content_io|
        @front_matter_as_yaml = YAML.parse front_matter
        @document_body = content_io.gets_to_end
      end
    end

    # report vars
    @infile = infile
    @changed = false
    @doc_stats = {} of Symbol => Int32
    @doc_stats[:unset_keys_num] = 0
    @doc_stats[:set_key_val_num] = 0
    @doc_stats[:replaced_keys_num] = 0
    @doc_stats[:replaced_vals_num] = 0
    @doc_stats[:replaced_formats_vars_num] = 0
    @doc_stats[:replaced_include_yaml_num] = 0
  end

  def toggle_bool_val_to_frontmatter(front_matter_key)
    yaml_processor = YamlHashProcessor.new(@front_matter_as_yaml)
    yaml_processor.process_node_toggle_key_bool_value(front_matter_key)
    store_process_data(yaml_processor)
  end

  def set_key_val_to_frontmatter(front_matter_key, front_matter_val)
    yaml_processor = YamlHashProcessor.new(@front_matter_as_yaml)
    yaml_processor.process_node_set_key_value(front_matter_key, front_matter_val)
    store_process_data(yaml_processor)
  end

  def replace_1st_level_frontmatter_variables
    yaml_processor = YamlHashProcessor.new(@front_matter_as_yaml)
    yaml_processor.process_node_replace_vars
    store_process_data(yaml_processor)
  end

  def replace_includes_in_frontmatter
    yaml_processor = YamlHashProcessor.new(@front_matter_as_yaml)
    infile_directory = File.dirname(@infile)
    yaml_processor.process_node_replace_includes(infile_directory)
    store_process_data(yaml_processor)
  end

  def unset_front_matter_key(front_matter_key)
    yaml_processor = YamlHashProcessor.new(@front_matter_as_yaml)
    yaml_processor.process_node_unset_front_matter_key(front_matter_key)
    store_process_data(yaml_processor)
  end

  def rename_front_matter_key(front_matter_key_old, front_matter_key_new)
    yaml_processor = YamlHashProcessor.new(@front_matter_as_yaml)
    yaml_processor.process_node_replace_front_matter_key(front_matter_key_old, front_matter_key_new)
    store_process_data(yaml_processor)
  end

  def rename_front_matter_val(front_matter_key, front_matter_val_old, front_matter_val_new)
    yaml_processor = YamlHashProcessor.new(@front_matter_as_yaml)
    yaml_processor.process_node_replace_front_matter_val(front_matter_key, front_matter_val_old, front_matter_val_new)
    store_process_data(yaml_processor)
  end

  private def store_process_data(yaml_processor)
    if yaml_processor.replaced_any || !@only_output_when_changed
      @front_matter_as_yaml = yaml_processor.front_matter_as_yaml
      @changed = true

      @doc_stats.each do |k, v|
        @doc_stats[k] = v + yaml_processor.process_stats[k]
      end

      # @doc_stats = yaml_processor.process_stats
    end
  end

  private def workaround_for_unicode_bug(in_string)
    in_string = in_string.gsub("\\xA9", "©")

    in_string = in_string.gsub("\\xE9", "é")
    in_string = in_string.gsub("\\xE8", "è")
    in_string = in_string.gsub("\\xEB", "ë")
    in_string = in_string.gsub("\\xEA", "ê")

    in_string = in_string.gsub("\\xFB", "û")
    in_string = in_string.gsub("\\xFC", "ü")
    in_string = in_string.gsub("\\xFA", "ú")

    in_string = in_string.gsub("\\xEF", "ï")
    in_string = in_string.gsub("\\xEE", "î")

    in_string = in_string.gsub("\\xE2", "â")
    in_string = in_string.gsub("\\xE1", "á")
    in_string = in_string.gsub("\\xE4", "ä")
    in_string = in_string.gsub("\\xE0", "à")

    in_string = in_string.gsub("\\xF3", "ó")
    in_string = in_string.gsub("\\xF2", "ò")
    in_string = in_string.gsub("\\xF6", "ö")
    in_string = in_string.gsub("\\xF4", "ô")

    in_string = in_string.gsub("\\xE7", "ç")
    in_string
  end

  def front_matter_string
    if (WORKAROUND_YAML_UNICODE_BUG)
      workaround_for_unicode_bug(@front_matter_as_yaml.to_yaml) + "---\n"
    else
      @front_matter_as_yaml.to_yaml + "---\n"
    end
  end

  def report_doc_stats
    print "\n"
    print "Stats for " + @infile + "\n"
    print "  Add YAML key/val combinations: " + @doc_stats[:set_key_val_num].to_s + "\n"
    print "  Unset YAML keys: " + @doc_stats[:unset_keys_num].to_s + "\n"
    print "  Replaced YAML keys: " + @doc_stats[:replaced_keys_num].to_s + "\n"
    print "  Replaced YAML vals: " + @doc_stats[:replaced_vals_num].to_s + "\n"
    print "  Replaced $FORMAT in YAML scalars: " + @doc_stats[:replaced_formats_vars_num].to_s + "\n"
    print "  Replaced $INCLUDE in YAML scalars: " + @doc_stats[:replaced_include_yaml_num].to_s + "\n"
    print "\n"
  end

  def markdown_string
    front_matter_string + @document_body
  end

  def dump_front_matter
    print front_matter_string
  end

  def dump_markdown
    print markdown_string
  end
end
