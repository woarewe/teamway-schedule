# frozen_string_literal: true

module Tests
  module Helpers
    module Authentication
      module_function

      include FactoryBot::Syntax::Methods
      extend FactoryBot::Syntax::Methods

      class TestOwner < ApplicationRecord; end

      def create_credentials(**params)
        credentials = default_attributes.merge(params)
        credentials[:record] = create(:authentication_credentials, **credentials)
        credentials
      end

      def create_token(username, password)
        Base64.encode64("#{username}:#{password}")
      end

      def with_auth_header(schema, value, **other_headers)
        other_headers.merge("Authorization" => "#{schema} #{value}")
      end

      def headers_with_auth(credentials, **other_headers)
        credentials => { username:, password: }
        token = create_token(username, password)
        with_auth_header("Bearer", token, **other_headers)
      end

      def default_attributes
        {
          owner: create_test_owner,
          username: Faker::Internet.unique.username,
          password: Faker::Internet.unique.password
        }
      end

      def create_test_owner
        create_test_owners_table
        TestOwner.create
      end

      def create_test_owners_table
        @create_test_owners_table ||= begin
          ActiveRecord::Base.connection_pool.with_connection do |connection|
            connection.create_table(:test_owners, &:timestamps) unless connection.table_exists?(:test_owners)
          end
          true
        end
      end
    end
  end
end
