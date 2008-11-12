def try_require_with_load_path(requirement, path=nil)
  $LOAD_PATH.push path unless path.nil?
  begin
    require requirement
    true
  rescue LoadError
    $LOAD_PATH.pop unless path.nil?
    false
  end
end

def try_require(requirement, env, *default_paths)
  loaded = try_require_with_load_path(requirement)

  unless loaded
    loaded = unless ENV[env].nil?
      try_require_with_load_path(requirement, ENV[env])
    else
      default_paths.any? { |path| try_require_with_load_path(requirement, path) }
    end
  end
  
  unless loaded
    abort <<-MSG
Please set the #{env} environment variable to the directory
containing the #{requirement}.rb file.
MSG
  end
  
end