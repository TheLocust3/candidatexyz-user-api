class Campaign < ApplicationRecord
  validates :name, presence: true

  has_many :users
  has_many :committees
end
