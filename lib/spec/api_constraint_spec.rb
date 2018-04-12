require 'rails_helper'

describe ApiConstraints do
  let(:api_v1) { ApiConstraints.new(version: 1) }
  let(:api_v2) { ApiConstraints.new(version: 2, default: true) }

  describe 'matches?' do
    it 'returns true when the version matches Accept header version' do
      request = double(host: 'api.marketplace.dev',
                       headers: {'Accept' => "application/yourgroup.com.v1"})
      expect(api_v1.matches?(request)).to be true

    end

    it 'returns deafult version when default option is specified' do
      request = double(host: 'yourgroup.com')
      expect(api_v2.matches?(request)).to be true
    end
  end
end