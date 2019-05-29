class User < ApplicationRecord
  has_one :zaim_user
  has_one :idm
end
