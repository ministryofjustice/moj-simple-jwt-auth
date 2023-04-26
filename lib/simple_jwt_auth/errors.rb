# frozen_string_literal: true

module SimpleJwtAuth
  module Errors
    class IssuerError < StandardError; end

    class UndefinedIssuer < IssuerError; end
    class UnknownIssuer < IssuerError; end
  end
end
