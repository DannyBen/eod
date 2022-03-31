require 'spec_helper'

describe API do
  before { require_mock_server! }
  subject { API.new api_token, use_cache: false }
  let(:api_token) { FAKE_API_TOKEN }

  describe '#new' do
    it "initializes with api token" do
      expect(subject.api_token).to eq api_token
    end

    it "initializes with options" do
      api = API.new api_token,
        use_cache: true,
        cache_dir: 'custom',
        cache_life: 1337

      expect(api.cache.dir).to eq 'custom'
      expect(api.cache.life).to eq 1337
      expect(api.cache).to be_enabled
    end
  end

  describe '#get_csv' do
    it "returns a csv string" do
      result = subject.get_csv "eod/AAPL.US"
      expect(result).to match_approval('eod.csv')
    end

    context "when the API returns non 200" do
      it "raises an error" do
        expect { subject.get_csv 'err/403' }
          .to raise_error(EOD::BadResponse, '403 Forbidden')
      end
    end
  end
end
