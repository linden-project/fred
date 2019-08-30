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

  def front_matter_string
    @front_matter_as_yaml.to_yaml + "---\n"
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
