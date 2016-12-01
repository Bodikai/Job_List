class SelfDependencyError < StandardError
end

class SelfDependencyValidator

  def validate_dependencies(hsh)
    hsh.each do |k, v|
      if k == v
        raise SelfDependencyError, "Jobs cannot be dependent on themselves"
      end
    end
  end

end

class CircularDependencyError < StandardError
end

class CircularDependencyValidator

  def validate_dependencies(hsh)
    hsh.each do |k, v|
      until v == ""
        if hsh.has_value?(v)
          v = hsh.fetch(v)
          if v == k
            raise CircularDependencyError, "Jobs cannot have circular dependencies"
          end
        else
          v == ""
        end
      end
    end
  end

end

class JobList

  def initialize
    @dependencies = Hash.new
    @jobs = []
  end

  def add(input)
    if input != ""
      @dependencies = parse(input)
      
      self_dependency_check = SelfDependencyValidator.new
      self_dependency_check.validate_dependencies(@dependencies)

      circular_dependency_check = CircularDependencyValidator.new
      circular_dependency_check.validate_dependencies(@dependencies)

      @jobs = prioritise(@dependencies)

    end
    jobs_to_string(@jobs)
  end

  def contains_circular_dependency?(hsh)
  end

  def parse(str)
    dependencies = Hash.new
    str.split(',').each { |j| dependencies[j.chr] = j.slice(1,j.length) }
    dependencies
  end

  def prioritise(hsh)
    arr = []
    hsh.each do |k, v| # for each KEY
      if v != "" # if HAS parent
        if arr.index(v) == nil # if parent does NOT EXIST
          if arr.index(k) == nil # if dependent does NOT EXIST
            arr << v # append parent
            arr << k # append dependent
          else
            arr.insert(arr.index(k), v) # insert parent
          end
        else
          arr.insert(arr.index(v)+1, k) # insert dependent AFTER parent
        end
      elsif arr.index(k) == nil
        arr << k # append INDEPENDENT job
      end
    end
    arr
  end

  def jobs_to_string(arr)
    arr.join(',')
  end

end