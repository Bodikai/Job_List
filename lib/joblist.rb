class CircularDependencyError < StandardError
  def message
    "Jobs cannot have circular dependencies"
  end
end

class CircularDependencyValidator
  def validate(hsh)
    hsh.each do |k, v|
      until v == ""
        if hsh.has_value?(v)
          v = hsh.fetch(v)
          if v == k
            raise CircularDependencyError
          end
        else
          v == ""
        end
      end
    end
    return nil
  end
end

class SelfDependencyError < StandardError
  def message
    "Jobs cannot be dependent on themselves"
  end
end

class SelfDependencyValidator
  def validate(hsh)
    hsh.each do |k, v|
      if k == v
        raise SelfDependencyError
      end
    end
    return nil
  end
end

class JobParser
  def initialize
    @dependencies = Hash.new
  end

  def parse(str)
    str.split(',').each { |j| @dependencies[j.chr] = j.slice(1,j.length) }
    @dependencies
  end
end

class JobPrioritiser
  def initialize(jobs = [])
    @jobs = jobs
  end

  def add_both_if_new(k, v)
    if v != "" && @jobs.index(v) == nil && @jobs.index(k) == nil
      @jobs << v << k
    end
  end

  def add_new_parent_if_dependent_exists(k, v)
    if v != "" && @jobs.index(v) == nil && @jobs.index(k) != nil
      @jobs.insert(@jobs.index(k), v)
    end
  end

  def add_new_dependent_if_parent_exists(k, v)
    if v != "" && @jobs.index(v) != nil && @jobs.index(k) == nil
      @jobs.insert(@jobs.index(v)+1, k)
    end
  end

  def add_new_independent(k, v)
    if v == "" && @jobs.index(k) == nil
      @jobs << k
    end
  end

  def prioritise(hsh)
    hsh.each do |k, v|
      add_both_if_new(k, v)
      add_new_parent_if_dependent_exists(k, v)
      add_new_dependent_if_parent_exists(k, v)
      add_new_independent(k, v)
    end
    show_jobs
  end

  def show_jobs
    @jobs
  end

end

class JobSorter
  def initialize
    @dependencies = Hash.new
    @jobs = []
  end

  def circular_dependency_validator
    CircularDependencyValidator.new
  end

  def parser
    JobParser.new
  end

  def prioritiser
    JobPrioritiser.new
  end

  def self_dependency_validator
    SelfDependencyValidator.new
  end

  def show_jobs
    @jobs
  end

  def sort(input)
    if input != ""
      @dependencies = parser.parse(input)
      self_dependency_validator.validate(@dependencies)
      circular_dependency_validator.validate(@dependencies)
      @jobs = prioritiser.prioritise(@dependencies)
    end
    show_jobs
  end
end

class JobList
  def add(input)
    show_jobs(sorter.sort(input))
  rescue CircularDependencyError, SelfDependencyError => error
    return error.message
  end

  def sorter
    JobSorter.new
  end

  def show_jobs(jobs)
    jobs.join(',')
  end
end