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
  end
end

class JobParser

  def initialize
    @dependencies = Hash.new
  end

  def parse_input(str)
    str.split(',').each { |j| @dependencies[j.chr] = j.slice(1,j.length) }
    @dependencies
  end
end

class JobPrioritiser

  def prioritise_jobs(hsh)
    @jobs = []
    hsh.each do |k, v| # for each KEY
      if v != "" # if HAS parent
        if @jobs.index(v) == nil # if parent does NOT EXIST
          if @jobs.index(k) == nil # if dependent does NOT EXIST
            @jobs << v << k # append parent then dependent
          else
            @jobs.insert(@jobs.index(k), v) # insert parent before dependent
          end
        else
          @jobs.insert(@jobs.index(v)+1, k) # insert dependent AFTER parent
        end
      elsif @jobs.index(k) == nil
        @jobs << k # append INDEPENDENT job
      end
    end
    @jobs
  end
end

class JobSorter
  def initialize
    @dependencies = Hash.new
    @jobs = []
  end

  def sort(input)
    if input != ""
      @dependencies = parser.parse_input(input)
      self_dependency_validator.validate(@dependencies)
      circular_dependency_validator.validate(@dependencies)
      @jobs = prioritiser.prioritise_jobs(@dependencies)
    end
    @jobs
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

  def circular_dependency_validator
    CircularDependencyValidator.new
  end
end

class JobList
  def initialize
    #@dependencies = Hash.new
    @jobs = []
  end

  def add(input)
    @jobs = sorter.sort(input)
    show_jobs
  rescue CircularDependencyError, SelfDependencyError => error
    return error.message
  end

  # Extract everything in ADD method apart from SHOW to new class Job_Parser
  # New class for parsing
  # New class for prio

  def sorter
    JobSorter.new
  end

  def show_jobs
    @jobs.join(',')
  end

end