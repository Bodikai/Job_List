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

end

class JobPrioritiser

end

class JobList
  def initialize
    @dependencies = Hash.new
    @jobs = []
  end

  def add(input)
    if input != ""
      parse_input(input)
      self_dependency_validator.validate(@dependencies)
      circular_dependency_validator.validate(@dependencies)
      prioritise_jobs
    end
    show_jobs
  rescue CircularDependencyError, SelfDependencyError => error
    return error.message
  end

  # Extract everything in ADD method apart from SHOW to new class Job_Parser
  # New class for parsing
  # New class for prio

  def self_dependency_validator
    SelfDependencyValidator.new
  end

  def circular_dependency_validator
    CircularDependencyValidator.new
  end

  def parse_input(str)
    str.split(',').each { |j| @dependencies[j.chr] = j.slice(1,j.length) }
  end

  def prioritise_jobs
    @dependencies.each do |k, v| # for each KEY
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
  end

  def show_jobs
    @jobs.join(',')
  end

end