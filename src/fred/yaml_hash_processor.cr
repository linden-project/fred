class YamlHashProcessor
  property replaced_keys_num : Int32
  property replaced_vals_num : Int32
  property replaced_formats_vars_num : Int32

  getter front_matter_as_yaml : YAML::Any

  def initialize(front_matter_as_yaml : YAML::Any)
    @set_key_val_num = 0
    @unset_keys_num = 0
    @replaced_keys_num = 0
    @replaced_vals_num = 0
    @replaced_formats_vars_num = 0
    @replaced_include_yaml_num = 0

    @front_matter_as_yaml = front_matter_as_yaml
    @glob_vars = {} of String => String
    setup_vars
  end

  def setup_vars
    @front_matter_as_yaml.as_h.each do |key, value|
      if value.raw.class == String
        @glob_vars[key.as_s] = value.as_s
      elsif value.raw.class == Int64
        @glob_vars[key.as_s] = value.raw.to_s
      elsif value.raw.class == Float64
        @glob_vars[key.as_s] = value.raw.to_s
      end
    end
  end

  def process_node_replace_vars
    @front_matter_as_yaml = _node_replace_vars(@front_matter_as_yaml)
  end

  def process_node_replace_includes(directory)
    @front_matter_as_yaml = _node_replace_includes(@front_matter_as_yaml, directory)
  end

  def process_node_replace_front_matter_val(front_matter_key, front_matter_val_old, front_matter_val_new)
    @front_matter_as_yaml = _node_replace_front_matter_val(@front_matter_as_yaml, front_matter_key, front_matter_val_old, front_matter_val_new)
  end

  def process_node_toggle_key_bool_value(key)
    @front_matter_as_yaml = _node_toggle_key_bool_val(@front_matter_as_yaml, key)
  end

  def process_node_set_key_value(key, val)
    @front_matter_as_yaml = _node_set_key_val(@front_matter_as_yaml, key, val)
  end

  def process_node_unset_front_matter_key(front_matter_key)
    @front_matter_as_yaml = _node_unset_front_matter_key(@front_matter_as_yaml, front_matter_key)
  end

  def process_node_replace_front_matter_key(front_matter_key_old, front_matter_key_new)
    @front_matter_as_yaml = _node_replace_front_matter_key(@front_matter_as_yaml, front_matter_key_old, front_matter_key_new)
  end

  def process_stats
    proc_stats = {} of Symbol => Int32
    proc_stats[:set_key_val_num] = @set_key_val_num
    proc_stats[:unset_keys_num] = @unset_keys_num
    proc_stats[:replaced_keys_num] = @replaced_keys_num
    proc_stats[:replaced_vals_num] = @replaced_vals_num
    proc_stats[:replaced_formats_vars_num] = @replaced_formats_vars_num
    proc_stats[:replaced_include_yaml_num] = @replaced_include_yaml_num

    proc_stats
  end

  def replaced_any
    return true if @unset_keys_num > 0
    return true if @set_key_val_num > 0
    return true if @replaced_keys_num > 0
    return true if @replaced_vals_num > 0
    return true if @replaced_formats_vars_num > 0
    return true if @replaced_include_yaml_num > 0
  end

  private def _node_replace_vars(node : YAML::Any)
    case node.raw
    when String
      return YAML::Any.new(string_value_replace_vars(node.as_s))
    when Array(YAML::Any)
      new_node = [] of YAML::Any
      node.as_a.each do |value|
        new_node << _node_replace_vars(value)
      end
      return YAML::Any.new(new_node)
    when Hash(YAML::Any, YAML::Any)
      new_node = {} of YAML::Any => YAML::Any
      node.as_h.each do |key, value|
        new_node[YAML::Any.new(key.as_s)] = _node_replace_vars(value)
      end
      return YAML::Any.new(new_node)
    else
      return node
    end

    node
  end

  private def _node_replace_includes(node : YAML::Any, directory)
    case node.raw
    when String
      # return node
      return string_value_replace_includes(node.as_s, directory)
    when Array(YAML::Any)
      new_node = [] of YAML::Any
      node.as_a.each do |value|
        new_node << _node_replace_includes(value, directory)
      end
      return YAML::Any.new(new_node)
    when Hash(YAML::Any, YAML::Any)
      new_node = {} of YAML::Any => YAML::Any
      node.as_h.each do |key, value|
        new_node[YAML::Any.new(key.as_s)] = _node_replace_includes(value, directory)
      end
      return YAML::Any.new(new_node)
    else
      return node
    end

    node
  end

  private def string_value_replace_includes(in_string : String, directory)
    m = in_string.match(/^\$INCLUDE\ (.*)/)
    if m
      begin
        yaml_path = File.expand_path(m[1], directory)
        include_yaml = File.open(yaml_path) { |file| YAML.parse(file) }
        @replaced_include_yaml_num += 1
        return include_yaml
      rescue
        p "ERROR: Could not process [#{in_string}], from dir [#{directory}]"
        YAML::Any.new(in_string)
      end
    else
      YAML::Any.new(in_string)
    end
  end

  private def string_value_replace_vars(in_string : String)
    new_string = in_string
    m = in_string.match(/^\$FORMAT\ (.*)/)
    if m
      new_string = m[1]

      @glob_vars.each do |k, v|
        if new_string.includes? k
          @replaced_formats_vars_num += 1
          new_string = new_string.gsub("{#{k}}", v)
        end
      end
    end

    return new_string
  end


  private def _node_toggle_key_bool_val(node : YAML::Any, front_matter_key)
    case node.raw
    when Hash(YAML::Any, YAML::Any)

      new_node = {} of YAML::Any => YAML::Any
      if node.as_h.keys.includes?(front_matter_key)
        node.as_h.each do |key, value|
          if key.as_s == front_matter_key
            if value.as_bool == true
              new_node[YAML::Any.new(key.as_s)] = YAML::Any.new(false)
            else
              new_node[YAML::Any.new(key.as_s)] = YAML::Any.new(true)
            end
            @set_key_val_num += 1
          else
            new_node[YAML::Any.new(key.as_s)] = value
          end
        end
      else
        node.as_h.each do |key, value|
          new_node[YAML::Any.new(key.as_s)] = value
        end
        new_node[YAML::Any.new(front_matter_key)] = YAML::Any.new(true)
        @set_key_val_num += 1
      end

      return YAML::Any.new(new_node)
    end

    return node
  end

  private def _node_set_key_val(node : YAML::Any, front_matter_key, front_matter_val)
    case node.raw
    when Hash(YAML::Any, YAML::Any)
      new_node = {} of YAML::Any => YAML::Any
      node.as_h.each do |key, value|
        new_node[YAML::Any.new(key.as_s)] = value
      end
      new_node[YAML::Any.new(front_matter_key)] = YAML::Any.new(front_matter_val)
      @set_key_val_num += 1
      return YAML::Any.new(new_node)
    end

    return node
  end

  private def _node_unset_front_matter_key(node : YAML::Any, front_matter_key)
    case node.raw
    when String
      return node
    when Array(YAML::Any)
      new_node = [] of YAML::Any
      node.as_a.each do |value|
        new_node << _node_unset_front_matter_key(value, front_matter_key)
      end
      return YAML::Any.new(new_node)
    when Hash(YAML::Any, YAML::Any)
      new_node = {} of YAML::Any => YAML::Any
      node.as_h.each do |key, value|
        if key.as_s == front_matter_key
          @unset_keys_num += 1
        else
          new_node[YAML::Any.new(key.as_s)] = value
        end
      end

      return YAML::Any.new(new_node)
    else
      return node
    end

    node
  end


  private def _node_replace_front_matter_key(node : YAML::Any, front_matter_key_old, front_matter_key_new)
    case node.raw
    when String
      return node
    when Array(YAML::Any)
      new_node = [] of YAML::Any
      node.as_a.each do |value|
        new_node << _node_replace_front_matter_key(value, front_matter_key_old, front_matter_key_new)
      end
      return YAML::Any.new(new_node)
    when Hash(YAML::Any, YAML::Any)
      new_node = {} of YAML::Any => YAML::Any
      node.as_h.each do |key, value|
        if key.as_s == front_matter_key_old
          @replaced_keys_num += 1
          new_node[YAML::Any.new(front_matter_key_new)] = _node_replace_front_matter_key(value, front_matter_key_old, front_matter_key_new)
        else
          new_node[YAML::Any.new(key.as_s)] = _node_replace_front_matter_key(value, front_matter_key_old, front_matter_key_new)
        end
      end

      return YAML::Any.new(new_node)
    else
      return node
    end

    node
  end

  private def _node_replace_front_matter_val(node : YAML::Any, front_matter_key, front_matter_val_old, front_matter_val_new)
    case node.raw
    when String
      return node
    when Array(YAML::Any)
      new_node = [] of YAML::Any
      node.as_a.each do |value|
        new_node << _node_replace_front_matter_val(value, front_matter_key, front_matter_val_old, front_matter_val_new)
      end
      return YAML::Any.new(new_node)
    when Hash(YAML::Any, YAML::Any)
      new_node = {} of YAML::Any => YAML::Any
      node.as_h.each do |key, value|
        if key.as_s == front_matter_key && value.as_s == front_matter_val_old
          new_node[YAML::Any.new(key.as_s)] = YAML::Any.new(front_matter_val_new)
          @replaced_vals_num += 1
        else
          new_node[YAML::Any.new(key.as_s)] = _node_replace_front_matter_val(value, front_matter_key, front_matter_val_old, front_matter_val_new)
        end
      end

      return YAML::Any.new(new_node)
    else
      return node
    end

    node
  end
end
