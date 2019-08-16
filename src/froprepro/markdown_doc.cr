class MarkdownDoc


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

  end

  def replace_1st_level_frontmatter_variables
      yaml_processor = YamlHashProcessor.new(@front_matter_as_yaml)
      @front_matter_as_yaml = yaml_processor.process_node_replace_vars(@front_matter_as_yaml)
  end

  def rename_taxo_key(taxo_key_old, taxo_key_new)
      yaml_processor = YamlHashProcessor.new(@front_matter_as_yaml)
      @front_matter_as_yaml = yaml_processor.process_node_replace_taxo_key(@front_matter_as_yaml, taxo_key_old, taxo_key_new)
  end

  def rename_taxo_val(taxo_key, taxo_val_old, taxo_val_new)
      yaml_processor = YamlHashProcessor.new(@front_matter_as_yaml)
      @front_matter_as_yaml = yaml_processor.process_node_replace_taxo_val(@front_matter_as_yaml, taxo_key, taxo_val_old, taxo_val_new)
  end

  def front_matter_string
    @front_matter_as_yaml.to_yaml + "---\n"
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
