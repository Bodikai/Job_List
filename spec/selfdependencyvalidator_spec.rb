require "joblist"

describe SelfDependencyValidator do

  let(:validator) { SelfDependencyValidator.new }

  describe ".validate" do

    context "given a list of jobs with no self-dependencies" do
      it "returns nil" do
        expect(validator.validate({"a" => "b"})).to eql(nil)
      end
    end

    context "given a list of jobs with self-dependencies" do
      it "raises a SelfDependencyError" do
        expect{validator.validate({"a" => "a"})}.to raise_error(SelfDependencyError)
      end
    end
  end
end