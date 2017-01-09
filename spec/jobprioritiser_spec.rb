require "joblist"

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

    context "given new dependent and new parent" do
      it "returns nil" do
        expect(prioritiser.add_new_parent_if_dependent_exists("a","b")).to eql(nil)
      end
    end

    context "given existing dependent and existing parent" do
      it "returns nil" do
        prioritiser = JobPrioritiser.new(["a, b"])
        expect(prioritiser.add_new_parent_if_dependent_exists("a","b")).to eql(nil)
      end
    end

    context "given existing dependent and new parent" do
      it "returns array containing new parent added before existnig dependent" do
        prioritiser = JobPrioritiser.new(["a"])
        expect(prioritiser.add_new_parent_if_dependent_exists("a","b")).to eql(["b","a"])
      end
    end
  end

  describe ".add_new_dependent_if_parent_exists" do

    context "given two parameters, the first a job and the second empty" do
      it "returns nil" do
        expect(prioritiser.add_new_dependent_if_parent_exists("a","")).to eql(nil)
      end
    end

    context "given new dependent and new parent" do
      it "returns nil" do
        expect(prioritiser.add_new_dependent_if_parent_exists("a","b")).to eql(nil)
      end
    end

    context "given existing dependent and existing parent" do
      it "returns nil" do
        prioritiser = JobPrioritiser.new(["a, b"])
        expect(prioritiser.add_new_dependent_if_parent_exists("a","b")).to eql(nil)
      end
    end    

    context "given new dependent and existing parent" do
      it "returns array containing new dependent added after existing parent" do
        prioritiser = JobPrioritiser.new(["b"])
        expect(prioritiser.add_new_dependent_if_parent_exists("a","b")).to eql(["b","a"])
      end
    end
  end

  describe ".add_new_independent" do

    context "given a new dependent job and parent" do
      it "returns nil" do
        expect(prioritiser.add_new_independent("a", "b")).to eql(nil)
      end
    end

    context "given an existing independent job" do
      it "returns nil" do
        prioritiser = JobPrioritiser.new(["a"])
        expect(prioritiser.add_new_independent("a", "")).to eql(nil)
      end
    end

    context "given a new independent job" do
      it "returns array with job appended" do
        expect(prioritiser.add_new_independent("a", "")).to eql(["a"])
      end
    end
  end

  describe ".prioritise" do

    context "when executed" do
      it "calls the add_both_if_new method" do
        expect(prioritiser).to receive(:add_both_if_new)
        prioritiser.prioritise("a" => "b")
      end
    end    

    context "when executed" do
      it "calls the add_new_parent_if_dependent_exists method" do
        expect(prioritiser).to receive(:add_new_parent_if_dependent_exists)
        prioritiser.prioritise("a" => "b")
      end
    end    

    context "when executed" do
      it "calls the add_new_dependent_if_parent_exists method" do
        expect(prioritiser).to receive(:add_new_dependent_if_parent_exists)
        prioritiser.prioritise("a" => "b")
      end
    end    

    context "when executed" do
      it "calls the add_new_independent method" do
        expect(prioritiser).to receive(:add_new_independent)
        prioritiser.prioritise("a" => "b")
      end
    end    
  end

  describe ".show_jobs" do

    context "given an array of jobs" do
      it "returns the same array of jobs" do
        prioritiser = JobPrioritiser.new(["a", "b", "c"])
        expect(prioritiser.show_jobs).to eql(["a", "b", "c"])
      end
    end

    context "given an empty array (of jobs)" do
      it "returns an empty array" do
        expect(prioritiser.show_jobs).to eql([])
      end
    end
  end
end