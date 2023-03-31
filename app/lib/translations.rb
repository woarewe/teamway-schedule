# frozen_string_literal: true

module Translations
  private

  def _translations_base_path
    self.class.name.split("::").map(&:underscore)
  end

  def t(path, **options)
    I18n.t(_translations_full_path(path), **options)
  end

  def t!(path, **options)
    I18n.t!(_translations_full_path(path), **options)
  end

  def _translations_full_path(path)
    [*_translations_base_path, path].join(".")
  end
end
