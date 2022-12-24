require 'spec_helper'

describe Command do
  subject { CLI.runner }

  before { require_mock_server! }

  # Test all commands as defined in the spec config
  config = YAML.load_file 'spec/eod/commands.yml'
  config.each do |name, command|
    context name do
      it 'executes successfully' do
        args = command.is_a?(Array) ? command : command.split
        expect { subject.run args }.to output_approval("cli/#{name}")
      end
    end
  end

  # Test other non-standard cases
  context 'with calendar command and an invalid calendar' do
    it 'raises a friendly error' do
      expect { subject.run %w[calendar holidays] }.to raise_approval('cli/calendar-invalid')
    end
  end

  context 'with any command and an invalid --format flag' do
    it 'raises a friendly error' do
      expect { subject.run %w[data SYMBOL --format xml] }.to raise_approval('cli/data-invalid-format')
    end
  end

  context 'with any command and --save' do
    let(:filename) { 'spec/tmp/out.json' }

    it 'saves the output to a file' do
      expect { subject.run %W[data SYMBOL --save #{filename}] }.to output_approval('cli/data-save')
      expect(File).to exist(filename)
    end
  end
end
