class Campaign < ApplicationRecord
  validates :name, presence: true
  validates :election_day, presence: true
  validates :preliminary_day, presence: true

  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :office_type, presence: true

  has_many :users
  has_many :committees
end
