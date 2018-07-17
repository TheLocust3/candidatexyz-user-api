class Campaign < ApplicationRecord
  validates :name, presence: true
  validates :election_day, presence: true

  has_many :users
  has_many :committees
end
