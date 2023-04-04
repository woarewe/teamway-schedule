# frozen_string_literal: true

module REST
  class API
    class Base < Grape::API
      format "json"

      def self.inherited(subclass)
        super
        subclass.instance_exec do
          before do
            authenticate!
          end
        end
      end
    end
  end
end
