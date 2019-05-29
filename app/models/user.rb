class User < ApplicationRecord
  has_one :zaim_user
  has_one :idm
  has_many :histories

  def bulk_create_histories(histories_attrs)
    reg_flg = false
    suc = 0

    attrs_rev = histories_attrs.reverse
    last_history = histories.last

    candidates = History.new_from_ic(attrs_rev, last_history.balance).map!{|history| history.user = self; history}

    candidates.each_with_index do |candidate, i|
      if reg_flg
        candidate.save!
      elsif candidate === last_history
        reg_flg = true
        suc = 20 - i - 1
      end
    end

    unless reg_flg
      candidates.each {|candidate| candidate.save!}
      reg_flg = true
      suc = 20
    end

    histories.last(suc)
  end

  def zaim_link
    ZaimLinkJob.perform_later
  end
end
