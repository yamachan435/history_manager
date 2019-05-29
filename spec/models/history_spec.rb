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

    it "is considered the same with common 6 paramaters." do
      history = History.new(@attr)
      another_attr = {
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
      another = History.new(another_attr)
      expect(history === another).to be_truthy
    end

    it "is considered the same without common 6 paramaters." do
      history = History.new(@attr)
      another_attr = {
        console: '改札機',
        process: :train_fare,
        date: '2019-05-29',
        in_station: '森林公園',
        out_station: '池袋',
        balance: 10000,
        created_at: Time.now,
        updated_at: Time.now,
        link_status: :unlinked,
        amount: 200,
        user_id: 1,
      }
      another = History.new(another_attr)
      expect(history === another).to be_falsey
    end

    it "is considered the same with the paramaters else." do
      history = History.new(@attr)
      another_attr = {
        console: '改札機',
        process: :train_fare,
        date: '2019-05-29',
        in_station: '志木',
        out_station: '池袋',
        balance: 10000,
        created_at: Time.now,
        updated_at: Time.now - 10,
        link_status: :unlinked,
        amount: 200,
        user_id: 1,
      }
      another = History.new(another_attr)
      expect(history === another).to be_truthy
    end
  end
end
