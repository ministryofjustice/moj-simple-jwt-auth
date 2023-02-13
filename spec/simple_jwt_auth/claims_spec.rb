# frozen_string_literal: true

RSpec.describe SimpleJwtAuth::Claims do
  before do
    SimpleJwtAuth.configure do |config|
      config.issuer = 'TestApp'
      config.exp_seconds = 120
    end

    allow(Time).to receive(:now).and_return(Time.new(2023, 01, 01))
  end

  describe '#to_h' do
    it 'returns a map of default claims' do
      expect(subject.to_h).to eq({exp: 1672531320, iat: 1672531200, iss: 'TestApp'})
    end
  end

  describe '#merge' do
    it 'merges other hash into the default claims' do
      expect(
        subject.merge(iss: 'OtherApp', foo: 'bar')
      ).to eq({exp: 1672531320, iat: 1672531200, iss: 'OtherApp', foo: 'bar'})
    end
  end
end
