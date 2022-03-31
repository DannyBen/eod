require 'spec_helper'

describe Refinements do
  using EOD::Refinements

  describe Array, '#translate_params' do
    subject { %w[order:asc from:2022-01-01] }

    it "converts an array of key:value to a hash" do
      expect(subject.translate_params).to eq({ from: "2022-01-01", order: "asc"})
    end

    it "returns an empty hash when the array is empty" do
      expect([].translate_params).to eq({})
    end
  end
end
