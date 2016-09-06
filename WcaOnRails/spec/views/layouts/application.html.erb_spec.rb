# frozen_string_literal: true
require "rails_helper"
require "capybara/rspec"

describe "layouts/application.html.erb" do
  describe "full_title" do
    it "renders title and does not escape apostrophes" do
      view.provide(:title, "Jeremy's awesome title")
      render
      expect(rendered).to have_title /^Jeremy's awesome title \| World Cube Association$/
    end
  end
end
