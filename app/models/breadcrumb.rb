# frozen_string_literal: true

# app/model/breadcrumb.rb
class Breadcrumb
  attr_reader :name, :path, :icon

  def initialize(name, path, icon)
    @name = name
    @path = path
    @icon = icon
  end

  def icon?
    @icon.present?
  end

  def link?
    @path.present?
  end
end
