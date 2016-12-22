# spec/job_list_spec.rb

require "joblist"

describe JobList do

  let(:joblist) { JobList.new() }

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

end
