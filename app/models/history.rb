class History < ApplicationRecord
  include Zaim::Zaim
  
  MEMO_STRING = '[HM AutomaticInput]'

  enum process: { train_fare: 1, charge: 2, ticket: 3, others: 6, bus_fare_2: 13, bus_fare: 15, window: 25, bus_charge: 31, purchase: 70, point_charge: 72, purchase_2: 198}
  enum link_status: { unlinked: 0, linked: 1 }

  belongs_to :user

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
      money = (charge? || bus_charge?) ? transfer : payment
      self.linked_at = Time.now.strftime("%F")
      self.zaim_id = money['money']['id']
      self.save!
      self.linked!
      return true
    end
  end

  def unlink
    if !linked?
      return false
    else
      (charge? || bus_charge?) ? delete('transfer') : delete('payment')
      self.unlinked!
      self.linked_at = nil
      self.zaim_id = nil
      self.save!
      return true
    end
  end
  
  class << self
    YEAR_PREFIX = 20
    def comparable_attr
      [:console, :process, :in_station, :out_station, :date, :balance]
    end

    def new_from_ic(attrs, balance)
      attrs.select!{|attr| attr['process'] != 0} 
      attrs.map!.with_index do |attr, i|
        attr['date'] = YEAR_PREFIX.to_s + attr['date'].to_s
        if i == 0
          attr['amount'] = balance - attr['balance']
        else
          attr['amount'] = attrs[i-1]['balance'] - attr['balance']
        end
        attr
      end
      attrs.map{|attr| History.new(attr)} 
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
      elsif ticket?
        { mapping: 1,
          category_id: 103,
          genre_id: 10303,
          amount: amount,
          date: date,
          from_account_id: 6,
          comment: '',
        }
      elsif others?
        { mapping: 1,
          category_id: 103,
          genre_id: 10303,
          amount: amount,
          date: date,
          from_account_id: 6,
          comment: '',
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
      elsif purchase_2?
        { mapping: 1,
          category_id: 199,
          genre_id: 19905,
          amount: amount,
          date: date,
          from_account_id: 6,
          comment: '',
        }
      elsif window?
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
      elsif bus_charge?
        { mapping: 1,
          amount: -amount,
          date: date,
          from_account_id: 1,
          to_account_id: 6,
          comment: '',
        }
      elsif point_charge?
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
