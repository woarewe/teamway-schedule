# frozen_string_literal: true

module REST
  class API < Grape::API
    format "json"
    prefix "api"

    helpers(
      Helpers::Authentication,
      Helpers::Validation,
      Helpers::Authorization
    )

    before do
      authenticate!
    end

    namespace(:organizations) { mount Organizations }
    namespace(:workers) { mount Workers }
    namespace(:shifts) { mount Shifts }

    add_swagger_documentation mount_path: "/swagger"
  end
end
