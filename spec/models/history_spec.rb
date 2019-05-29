require 'rails_helper'

RSpec.describe History, type: :model do
  it "is valid with valid paramaters" do
    history = History.new()
    expect(history).to be_valid
  end
end
