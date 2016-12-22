# spec/job_list_spec.rb

require "joblist"

describe JobList do

  let(:joblist) { JobList.new }

  describe ".add" do

    context "given an empty string" do
      it "returns existing empty joblist" do
        expect(joblist.add("")).to eql("")
      end
    end

    context "given only 'a'" do
      it "returns only the one original job" do
        expect(joblist.add("a")).to eql("a")
      end
    end

    context "given 'a,b,c' with no dependencies" do
      it "returns new jobs in the original order" do
        expect(joblist.add("a,b,c")).to eql("a,b,c")
      end
    end

    context "given 'a,bc,c'" do
      it "returns new jobs with dependent jobs in the correct order" do
        expect(joblist.add("a,bc,c")).to eql("a,c,b")
      end
    end

    context "given 'a,bc,cf,da,eb,f'" do
      it "returns new jobs with dependent jobs in the correct order" do
        expect(joblist.add("a,bc,cf,da,eb,f")).to eql("a,d,f,c,b,e")
      end
    end

    context "given 'a,b,cc' where 'c' is dependent on itself" do
      it "raises self-dependency error" do
        expect(joblist.add("a,b,cc")).to eql("Jobs cannot be dependent on themselves") 
      end
    end

    context "given 'a,bc,cf,da,e,fb' where b, c and f are in a circular dependency" do
      it "returns circular dependency error" do
        expect(joblist.add("a,bc,cf,da,e,fb")).to eql("Jobs cannot have circular dependencies")
      end
    end
  end

  describe ".show_jobs" do

    context "given an array of jobs" do
      it "returns the jobs in a string separated by a comma" do
        expect(joblist.show_jobs(["a","b","c"])).to eql("a,b,c")
      end
    end

    context "given an empty array (of jobs)" do
      it "returns an empty string" do
        expect(joblist.show_jobs([])).to eql("")
      end
    end

  end
end

describe JobSorter do

  let(:sorter) { JobSorter.new }

  describe ".sort" do

    context "given a string containing a list of jobs" do
      it "returns the prioritised jobs in an array" do
        expect(sorter.sort("ab,b,c")).to eql(["b","a","c"])
      end
    end

    context "given an empty string" do
      it "returns an empty array" do
        expect(sorter.sort("")).to eql([])
      end
    end

  end
end

describe JobPrioritiser do

  let(:prioritiser) { JobPrioritiser.new }

  describe ".add_both_if_new" do

    context "given two parameters, the first a job and the second empty" do
      it "returns nil" do
        expect(prioritiser.add_both_if_new("a","")).to eql(nil)
      end
    end

    context "given existing job 'a' which depends on new job 'b'" do
      it "returns nil" do
        prioritiser = JobPrioritiser.new(["a"])
        expect(prioritiser.add_both_if_new("a","b")).to eql(nil)
      end
    end

    context "given new job 'a' which depends on existing job 'b'" do
      it "returns nil" do
        prioritiser = JobPrioritiser.new(["b"])
        expect(prioritiser.add_both_if_new("a","b")).to eql(nil)
      end
    end

    context "given two new jobs 'a' and 'b' where 'a' depends on 'b'" do
      it "returns both jobs with 'b' before 'a' added to the existing array" do
        expect(prioritiser.add_both_if_new("a","b")).to eql(["b","a"])
      end
    end

  end

  describe ".add_new_parent_if_dependent_exists" do

    context "given two parameters, the first a job and the second empty" do
      it "returns nil" do
        expect(prioritiser.add_new_parent_if_dependent_exists("a","")).to eql(nil)
      end
    end

    context "given new parent and new dependent" do
      it "returns nil" do
        expect(prioritiser.add_new_parent_if_dependent_exists("a","b")).to eql(nil)
      end
    end

    context "given existing parent and existing dependent" do
      it "returns nil" do
        prioritiser = JobPrioritiser.new(["a, b"])
        expect(prioritiser.add_new_parent_if_dependent_exists("a","b")).to eql(nil)
      end
    end

    context "given new parent and existing dependent" do
      it "returns new parent added before dependent in existing array" do
        prioritiser = JobPrioritiser.new(["a"])
        expect(prioritiser.add_new_parent_if_dependent_exists("a","b")).to eql(["b","a"])
      end
    end
    
  end

end