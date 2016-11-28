# spec/job_list_spec.rb

require "joblist"

describe JobList do

  let(:joblist) { JobList.new() }

  describe ".add" do
    context "given an empty string and no existing jobs" do
      it "returns existing empty joblist" do
        expect(joblist.add("")).to eql("")
      end
    end
  end

  # TO DO: Test for empty string and some existing jobs

  describe ".add" do
    context "given 'a,b,c' with no dependencies and no existing jobs" do
      it "returns new jobs in the original order" do
        expect(joblist.add("a,b,c")).to eql("a,b,c")
      end
    end
  end

  describe ".add" do
    context "given 'ab,b' and no existing jobs" do
      it "returns jobs ordered by dependency" do
        expect(joblist.add("ab,b")).to eql("b,a")
      end
    end
  end

  describe ".add" do
    context "given 'b,c,a' (no dependencies) and no existing jobs" do
      it "returns new jobs in alphabetic order" do
        expect(joblist.add("b,c,a")).to eql("b,c,a")
      end
    end
  end

  describe ".add" do
    context "given 'a,bc,c' and no existing jobs" do
      it "returns new jobs with priorty on dependencies" do
        expect(joblist.add("a,bc,c")).to eql("a,c,b")
      end
    end
  end

  describe ".add" do
    context "given 'a,bc,cf,da,eb,f' and no existing jobs" do
      it "returns new jobs with priority on dependencies" do
        expect(joblist.add("a,bc,cf,da,eb,f")).to eql("a,d,f,c,b,e")
      end
    end
  end

=begin

  describe ".add" do
    context "given 'a,b,cc' where c is dependent on itself" do
      it "returns error stating jobs cannot be dependent on themselves" do
        expect(joblist.add("a,b,cc")).to eql("Jobs cannot be dependent on themselves")
      end
    end
  end

  describe ".add" do
    context "given 'a,bc,cf,da,e,fb' where b, c and f are in a circular dependency" do
      it "returns error stating jobs cannot have circular dependencies" do
        expect(joblist.add("a,bc,cf,da,e,fb")).to eql("Jobs cannot have circular dependencies")
      end
    end
  end

=end

end