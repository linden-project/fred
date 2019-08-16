class MarkdownDoc


  def initialize(infile : String)

    in_yaml_string = ""
    in_body_string = ""

#    @front_matter_as_yaml : YAML::Any
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
      @front_matter_as_yaml = yaml_processor.process_node(@front_matter_as_yaml)
  end

  def dump_markdown
    print @front_matter_as_yaml.to_yaml
    print "---\n"
    print @document_body
  end


end
