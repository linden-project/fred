require "clim"
require "front_matter"
require "yaml"
require "./froprepro/*"

class YamlHashProcessor

  def initialize(data : YAML::Any)
    @processed_data = data
    @glob_vars = {} of String => String
  end

  def setup_vars(node : YAML::Any)

    node.as_h.each do |key, value|

      if value.raw.class == String
        @glob_vars[key.as_s] = value.as_s

      elsif value.raw.class == Int64
        @glob_vars[key.as_s] = value.raw.to_s

      elsif value.raw.class == Float64
        @glob_vars[key.as_s] = value.raw.to_s

      end
    end
  end

  def string_value_process(in_string : String)

    new_string = in_string
    m = in_string.match(/^\$FORMAT\ (.*)/)
    if m
      new_string = m[1]

      @glob_vars.each do |k,v|

        if new_string.includes? k
          new_string = new_string.gsub("{#{k}}",v)
        end

      end
    end

    return new_string
  end

  def clean_node( node : YAML::Any)

    case node.raw

    when String

      return YAML::Any.new(string_value_process(node.as_s))

    when Array(YAML::Any)
      new_node = [] of YAML::Any
      node.as_a.each do |value|
        new_node << clean_node( value )
      end
      return YAML::Any.new(new_node)

    when Hash(YAML::Any, YAML::Any)
      new_node = {} of YAML::Any => YAML::Any

      node.as_h.each do |key, value|
        new_node[YAML::Any.new(key.as_s)] = clean_node( value )
      end

      return YAML::Any.new(new_node)

    else
      return node
    end

    node

  end
end



module Froprepro

  class Cli < Clim

    main do
      desc "help"
      usage "froprepro help"
      run do |opts, args|
        puts opts.help_string
      end

      sub "proc" do
        desc "process front matter"
        usage "froprepro proc [MARKDOWN FILE]"
        run do |opts, args|

          if args.size == 1
            infile = File.expand_path(args[0])

            if File.file?(infile)
              FrontMatter.open(infile, false) do|front_matter, content_io|
                data = YAML.parse front_matter
                yamlprocessor = YamlHashProcessor.new(data)
                yamlprocessor.setup_vars(data)
                print yamlprocessor.clean_node(data).to_yaml
                print "---\n"
                print content_io.gets_to_end
              end
            end

          end
        end
      end

    end
  end
end

Froprepro::Cli.start(ARGV)
