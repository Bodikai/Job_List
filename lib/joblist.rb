class JobList

  def initialize
    @jobs = ""
  end

  def add(input)
    if input == ""
      "No jobs added"
    else
      @jobs << (@jobs == "" ? input : ',' + input)
      "Jobs '#{input}' added"
    end
  end

  def check_format
    # Check that inputted string is formatted correctly

  end

  def sort(s)
    # Split incoming string (ie. newly added jobs)
  end

  def show
    # Show current jobs
  end

end