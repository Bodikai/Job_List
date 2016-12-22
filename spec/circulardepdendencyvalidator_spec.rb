require "joblist"

describe CircularDependencyValidator do

  let(:validator) { CircularDependencyValidator.new }

  describe ".validate" do

    context "given a list of jobs with no circular dependencies" do
      it "returns nil" do
        expect(validator.validate({"a" => "b", "b" => ""})).to eql(nil)
      end
    end

    context "given a list of jobs with circular dependencies" do
      it "raises a CircularDependencyError" do
        expect{validator.validate({"a" => "b", "b" => "a"})}.to raise_error(CircularDependencyError)
      end
    end
  end
end