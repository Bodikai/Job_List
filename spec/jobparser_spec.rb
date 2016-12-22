require "joblist"

describe JobParser do

  let(:parser) { JobParser.new }

  describe ".parse" do

    context "given an empty string" do
      it "returns an empty hash" do
        expect(parser.parse("")).to eql(Hash.new)
      end
    end

    context "given a properly formatted string containing pair of dependent jobs" do
      it "returns a hash containing the jobs in the string" do
        expect(parser.parse("ab")).to eql({"a" => "b"})
      end
    end

    context "given a properly formatted string containing several jobs" do
      it "returns a hash containing the jobs in the string" do
        expect(parser.parse("ab,c,d")).to eql({"a" => "b","c" => "", "d" => ""})
      end
    end
  end
end