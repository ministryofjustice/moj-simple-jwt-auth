# frozen_string_literal: true

RSpec.describe SimpleJwtAuth::Errors do
  subject { Class.new { extend SimpleJwtAuth::Errors } }

  context 'Error subclasses' do
    it 'Forbidden is a subclass of StandardError' do
      expect(described_class::Forbidden).to be < StandardError
    end

    it 'IssuerError is a subclass of StandardError' do
      expect(described_class::IssuerError).to be < StandardError
    end

    it 'UndefinedIssuer is a subclass of IssuerError' do
      expect(described_class::UndefinedIssuer).to be < described_class::IssuerError
    end

    it 'UnknownIssuer is a subclass of IssuerError' do
      expect(described_class::UnknownIssuer).to be < described_class::IssuerError
    end
  end
end
