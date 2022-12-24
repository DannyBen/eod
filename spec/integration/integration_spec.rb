require 'spec_helper'

describe 'Integration', :require_test_api_token do
  subject { CLI.runner }

  before do
    EOD::API.base_uri PRODUCTION_API_BASE
    ENV['EOD_API_TOKEN'] = ENV['EOD_TEST_API_TOKEN']
  end

  after do
    EOD::API.base_uri TEST_API_BASE
    ENV['EOD_API_TOKEN'] = FAKE_API_TOKEN
  end

  # Test all commands as defined in the spec config
  config = YAML.load_file 'spec/integration/commands.yml'
  config.each do |name, command|
    context name do
      it 'executes successfully' do
        args = command.is_a?(Array) ? command : command.split

        if args.first == '!'
          args = args.drop 1
          expect { subject.run args }
            .to output_approval("integration/#{name}")

        else
          expect { subject.run args }
            .to output_approval("integration/#{name}")
            .except(/(-?\d)+/, '#')

        end
      end
    end
  end
end
