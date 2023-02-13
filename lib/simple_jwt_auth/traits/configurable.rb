# frozen_string_literal: true

module SimpleJwtAuth
  module Traits
    module Configurable
      private

      def config
        SimpleJwtAuth.configuration
      end

      def secrets
        SimpleJwtAuth.secrets
      end
    end
  end
end
