require "joblist"

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