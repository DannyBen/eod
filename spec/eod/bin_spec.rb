require 'spec_helper'

describe 'bin/eod' do
  subject { CLI.runner }

  context "on error" do
    it "displays it nicely" do
      expect(`bin/eod calendar invalid-calendar 2>&1`).to match_approval('cli/error')
    end
  end
end
