require 'spec_helper'

describe API do
  subject { described_class.new api_token, use_cache: false }

  before { require_mock_server! }

  let(:api_token) { FAKE_API_TOKEN }

  describe '#new' do
    it 'initializes with api token' do
      expect(subject.api_token).to eq api_token
    end

    context 'with options' do
      subject do
        described_class.new api_token,
          use_cache:  true,
          cache_dir:  'custom',
          cache_life: 1337
      end

      it 'initializes properly' do
        expect(subject.cache.dir).to eq 'custom'
        expect(subject.cache.life).to eq 1337
        expect(subject.cache).to be_enabled
      end
    end
  end

  describe '#get_csv' do
    it 'returns a csv string' do
      result = subject.get_csv 'eod/AAPL.US'
      expect(result).to match_approval('eod.csv')
    end

    context 'when the API returns non 200' do
      it 'raises an error' do
        expect { subject.get_csv 'err/403' }
          .to raise_error(EOD::BadResponse, '403 Forbidden')
      end
    end
  end
end
