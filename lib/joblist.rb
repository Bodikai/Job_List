class JobList

  def initialize
    @jobs = Hash.new
  end

  def add(input)
    if input != ""
      @jobs = parse(input)
    end
    show
  end

  def parse(str)
    str.split(',').each { |j| @jobs[j.chr] = j.slice(1,j.length) }
    @jobs
  end

  def show
    @jobs.keys.join(',')
  end

  def prioritise
    # PRIORITY 1 - Jobs with longest dependency chain
    # PRIORITY 2 - Alphabetic order
    # e.g. "b,c,e" (dependent) have priority over "a,f" (dependent),
    #      d" and "g", resulting in "b,c,e,a,f,d,g"
    @jobs.sort!
  end

end