require 'rails_helper'

RSpec.describe "notes/index", type: :view do
  before(:each) do
    assign(:notes, [
      Note.create!(),
      Note.create!()
    ])
  end

  it "renders a list of notes" do
    render
  end
end
