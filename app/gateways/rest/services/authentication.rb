# frozen_string_literal: true

module REST
  module Services
    class Authentication
      include Translations

      HEADER = "Authorization"
      SCHEME = "Bearer"

      Error = Class.new(StandardError)

      def call(headers)
        payload = header_payload!(headers)
        username, password = parse_payload!(payload)
        authenticate!(username, password)
      end

      private

      def header_payload!(headers)
        raise Error, t!("errors.missing_header", header: HEADER) unless headers.key?(HEADER)

        headers.fetch(HEADER)
      end

      def parse_payload!(payload)
        scheme, token = payload.split
        invalid_format! if invalid_scheme?(scheme)

        Base64
          .decode64(token.to_s)
          .then { |decoded| decoded.split(":") }
          .tap { |username, password| invalid_format! if username.nil? || password.nil? }
      end

      def authenticate!(username, password)
        creds = ::Authentication::Credentials.find_by(username:)
        invalid_creds! if creds.nil?
        invalid_creds! unless creds.authenticate(password)

        creds.owner
      end

      def invalid_format!
        raise Error, t!("errors.invalid_format", header: HEADER, scheme: SCHEME)
      end

      def invalid_creds!
        raise Error, t!("errors.invalid_creds")
      end

      def invalid_scheme?(scheme)
        scheme != SCHEME
      end
    end
  end
end
