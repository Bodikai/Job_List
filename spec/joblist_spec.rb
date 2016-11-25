# spec/job_list_spec.rb

require "joblist"

describe JobList do

  let(:joblist) { JobList.new() }

  describe ".add" do
    context "given an empty string" do
      it "returns no jobs added" do
        expect(joblist.add("")).to eql("No jobs added")
      end
    end
  end

  describe ".add" do
    context "given 'a,b'" do
      it "returns new jobs" do
        expect(joblist.add("a,b")).to eql("Jobs 'a,b' added")
      end
    end
  end

end