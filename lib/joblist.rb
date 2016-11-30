class JobList

  def initialize
    @dependencies = Hash.new
    @jobs = []
  end

  def add(input)
    if input != ""
      @dependencies = parse(input)
      if contains_self_dependency?(@dependencies)
        return "Jobs cannot be dependent on themselves"
      elsif contains_circular_dependency?(@dependencies)
        return "Jobs cannot have circular dependencies"
      else
        @jobs = prioritise(@dependencies)
      end
    end
    jobs_to_string(@jobs)
  end

  def contains_circular_dependency?(hsh)
    hsh.each do |k, v|
      until v == ""
        if hsh.has_value?(v)
          v = hsh.fetch(v)
          if v == k
            return true
          end
        else
          v == ""
        end
      end
    end
    false
  end

  def contains_self_dependency?(hsh)
    hsh.each do |k, v|
      if k == v
        return true
      end
    end
    false
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