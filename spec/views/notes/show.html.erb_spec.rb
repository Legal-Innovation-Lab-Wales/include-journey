require 'rails_helper'

RSpec.describe "notes/show", type: :view do
  before(:each) do
    @note = assign(:note, Note.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
