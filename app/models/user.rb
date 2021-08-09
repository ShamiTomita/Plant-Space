class User < ActiveRecord::Base
  has_secure_password
  has_one   :garden
  has_many  :plants, through: :garden
  validates :username, :presence => true,
                       :uniqueness => true
  validates :email,    :presence => true,
                       :uniqueness => true,
                       :format => {:with => /\w+@\w+\.\w+/}
end
