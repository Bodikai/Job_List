class JobList

  def initialize
    @jobs = ""
  end

  def add(input)
    if input != ""
      @jobs << (@jobs == "" ? input : ',' + input)
    end
    @jobs
  end

  def check_format
    # Check that input string is formatted correctly

  end

  def sort(s)
    # Split incoming string (ie. newly added jobs)
  end

  def to_array(s)

  end

  def show
    # Show current jobs
  end

end