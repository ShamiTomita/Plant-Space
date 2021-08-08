class User < ActiveRecord::Base
  has_secure_password
  has_one :garden
  has_many :plants, through: :garden
end
