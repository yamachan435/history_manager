class History < ApplicationRecord
  include Zaim::Zaim
  
  MEMO_STRING = '[HM AutomaticInput]'

  enum process: { train_fare: 1, charge: 2, bus_fare_2: 13, bus_fare: 15, purchase: 70}
  enum link_status: { unlinked: 0, linked: 1 }

  def ===(other)
    History.comparable_attr.each do |attr|
      return false if send(attr) != other.send(attr)
    end
    return true
  end

  def link
    if linked?
      return false
    else
      money = charge? ? transfer : payment
      self.linked!
      self.linked_at = Time.now.strftime("%F")
      self.zaim_id = money['money']['id']
      self.save!
      return true
    end
  end

  def unlink
    if !linked?
      return false
    else
      charge? ? delete('transfer') : delete('payment')
      self.unlinked!
      self.linked_at = nil
      self.zaim_id = nil
      self.save!
      return true
    end
  end
  
  class << self
    def comparable_attr
      [:console, :process, :in_station, :out_station, :date, :balance]
    end
  end

  private
  def to_zaim
    zaim_hash = 
      if train_fare?
        { mapping: 1,
          category_id: 103,
          genre_id: 10301,
          amount: amount,
          date: date,
          from_account_id: 6,
          comment: "#{in_station}→#{out_station}",
        }
      elsif bus_fare?
        { mapping: 1,
          category_id: 103,
          genre_id: 10303,
          amount: amount,
          date: date,
          from_account_id: 6,
          comment: '',
        }
      elsif bus_fare_2?
        { mapping: 1,
          category_id: 103,
          genre_id: 10303,
          amount: amount,
          date: date,
          from_account_id: 6,
          comment: '',
        }
      elsif purchase?
        { mapping: 1,
          category_id: 199,
          genre_id: 19905,
          amount: amount,
          date: date,
          from_account_id: 6,
          comment: '',
        }
      elsif charge?
        { mapping: 1,
          amount: -amount,
          date: date,
          from_account_id: 1,
          to_account_id: 6,
          comment: '',
        }
      end
    zaim_hash[:comment] = "#{MEMO_STRING}\n#{zaim_hash[:comment]}"
    return zaim_hash
  end
end
