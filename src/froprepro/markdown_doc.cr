class MarkdownDoc

  getter changed

  def initialize(infile : String)

    in_yaml_string = ""
    in_body_string = ""

    @document_body = String.new

    FrontMatter.open(infile, false) do |front_matter, content_io|
      in_yaml_string = front_matter
      in_body_string = content_io.gets_to_end
    end

    @front_matter_as_yaml = YAML.parse in_yaml_string
    @document_body = in_body_string

    # report vars
    @infile = infile
    @changed = false
    @doc_stats = {} of Symbol => Int32
    @doc_stats[:replaced_keys_num] = 0
    @doc_stats[:replaced_vals_num] = 0
    @doc_stats[:replaced_formats_vars_num] = 0

  end

  def replace_1st_level_frontmatter_variables
      yaml_processor = YamlHashProcessor.new(@front_matter_as_yaml)
      yaml_processor.process_node_replace_vars
      store_process_data(yaml_processor)
  end

  def rename_taxo_key(taxo_key_old, taxo_key_new)

      yaml_processor = YamlHashProcessor.new(@front_matter_as_yaml)
      yaml_processor.process_node_replace_taxo_key(taxo_key_old, taxo_key_new)
      store_process_data(yaml_processor)
  end

  def rename_taxo_val(taxo_key, taxo_val_old, taxo_val_new)

      yaml_processor = YamlHashProcessor.new(@front_matter_as_yaml)
      yaml_processor.process_node_replace_taxo_val(taxo_key, taxo_val_old, taxo_val_new)
      store_process_data(yaml_processor)
  end

  private def store_process_data(yaml_processor)
    if yaml_processor.replaced_any
      @front_matter_as_yaml = yaml_processor.front_matter_as_yaml
      @changed = true
      @doc_stats = yaml_processor.process_stats
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
    workaround_for_unicode_bug(@front_matter_as_yaml.to_yaml)
  end

  def report_doc_stats
    print "\n"
    print "Stats for " + @infile + "\n"
    print "  Replaced YAML keys: " + @doc_stats[:replaced_keys_num].to_s + "\n"
    print "  Replaced YAML vals: " + @doc_stats[:replaced_vals_num].to_s + "\n"
    print "  Replaced $FORMATS in YAML vals: " + @doc_stats[:replaced_formats_vars_num].to_s + "\n"
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
