
class Garden < ActiveRecord::Base
  belongs_to :user
  has_many :plants
end
