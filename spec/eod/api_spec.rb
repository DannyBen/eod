require 'spec_helper'

describe API do
  subject { API.new api_token, **options }
  let(:options) { {} }
  let(:api_token) { public_api_token }

  describe '#new' do
    let(:api_token) { 'fake-test-token' }

    it "initializes with api token" do
      expect(subject.api_token).to eq api_token
    end

    it "starts with cache configured" do
      expect(subject.cache).to be_enabled
      expect(subject.cache.life).to eq 3600
      expect(subject.cache.dir).to eq 'cache'
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
      result = subject.get_csv "eod/#{public_eod_sumbol}",
        period: 'w', from: '2022-01-01', to: '2022-02-01'

      expect(result).to match_approval('eod.csv').except(/\d/, '#')
    end

    context "when the API returns non 200" do
      it "raises an error" do
        expect { subject.get_csv 'eod/INVALID.SYMBOL' }
          .to raise_error(EOD::BadResponse, '403 Forbidden')
      end
    end
  end
end
