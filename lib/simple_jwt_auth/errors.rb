# frozen_string_literal: true

module SimpleJwtAuth
  module Errors
    class UndefinedIssuer < StandardError; end
    class UnknownIssuer < StandardError; end
  end
end
