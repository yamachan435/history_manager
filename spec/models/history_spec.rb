require 'rails_helper'

RSpec.describe History, type: :model do
  describe 'type: train_fare' do
    before do
      User.new({id: 1, name: 'example'}).save!
      @attr = {
        console: '改札機',
        process: :train_fare,
        date: '2019-05-29',
        in_station: '志木',
        out_station: '池袋',
        balance: 10000,
        created_at: Time.now,
        updated_at: Time.now,
        link_status: :unlinked,
        amount: 200,
        user_id: 1,
      }
    end

    it "is valid with valid paramaters." do
      history = History.new(@attr)
      expect(history).to be_valid
    end
  end
end
