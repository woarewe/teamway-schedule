# frozen_string_literal: true

class API < Grape::API
  format "json"
  prefix "api"

  get "/hello" do
    "World !"
  end

  add_swagger_documentation mount_path: "/swagger"
end
