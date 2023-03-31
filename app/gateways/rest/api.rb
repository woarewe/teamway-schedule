# frozen_string_literal: true

module REST
  class API < Grape::API
    format "json"
    prefix "api"

    helpers Helpers::Auth

    before do
      authenticate!
    end

    get "hello" do
      "World"
    end

    add_swagger_documentation mount_path: "/swagger"
  end
end
