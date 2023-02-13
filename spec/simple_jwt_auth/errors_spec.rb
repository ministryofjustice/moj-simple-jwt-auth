# frozen_string_literal: true

RSpec.describe SimpleJwtAuth::Errors do
  subject { Class.new { extend SimpleJwtAuth::Errors } }

  context 'Error subclasses' do
    it 'UndefinedIssuer is a subclass of StandardError' do
      expect(described_class::UndefinedIssuer).to be < StandardError
    end

    it 'UnknownIssuer is a subclass of StandardError' do
      expect(described_class::UnknownIssuer).to be < StandardError
    end
  end
end
