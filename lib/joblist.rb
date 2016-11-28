class JobList

  def initialize
    @dependencies = Hash.new
    @jobs = []
  end

  def add(input)
    if input != ""
      @dependencies = parse(input)
      if contains_self_dependency?(@dependencies)
        @dependencies = Hash.new
        return "Jobs cannot be dependent on themselves"
      else
        @jobs = prioritise(@dependencies)
      end
    end
    show
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
    str.split(',').each { |j| @dependencies[j.chr] = j.slice(1,j.length) }
    @dependencies
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

  def show
    @jobs.join(',')
  end

end