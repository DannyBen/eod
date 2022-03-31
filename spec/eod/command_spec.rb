require 'spec_helper'

describe Command do
  subject { CLI.runner }

  config = YAML.load_file 'spec/eod/commands.yml'

  # Test all commands as defined in the spec config
  config.each do |name, command|
    context name do
      it "works" do
        expect { subject.run command.split(' ') }.to output_approval("cli/#{name}")
      end
    end
  end

  # Test other non-standard cases
  context "calendar command with an invalid calendar" do
    it "raises a friendly error" do
      expect { subject.run %w[calendar holidays] }.to raise_approval("cli/calendar-invalid")
    end
  end

  context "any command with an invalid --format flag" do
    it "raises a friendly error" do
      expect { subject.run %w[data SYMBOL --format xml] }.to raise_approval("cli/data-invalid-format")
    end
  end

  context "any command with --save" do
    let(:filename) { 'spec/tmp/out.json' }

    it "saves the output to a file" do
      expect { subject.run %W[data SYMBOL --save #{filename}] }.to output_approval("cli/data-save")
      expect(File).to exist(filename)
    end
  end
end
