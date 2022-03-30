require 'spec_helper'

describe Command do
  subject { CLI.runner }

  context "without arguments" do
    it "shows long usage" do
      expect { subject.run %w[] }.to output_approval('cli/usage')
    end
  end

  context "--help" do
    it "shows long usage" do
      expect { subject.run %w[--help] }.to output_approval('cli/help')
    end
  end
end
