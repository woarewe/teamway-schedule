# frozen_string_literal: true

module ExternalID
  extend ActiveSupport::Concern

  included do
    after_create :reload_external_id
  end

  def initialize_copy(_other)
    super

    self[:external_id] = nil
  end

  def reload_external_id
    self[:external_id] = self.class.unscoped.where(id:).pick(:external_id)
  end
end
