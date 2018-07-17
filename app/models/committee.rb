class Committee < ApplicationRecord
  before_validation :sanitize_phone_number

  validates :name, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true, number: true

  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true

  validates :office, presence: true
  validates :district, presence: true

  validates :bank, presence: true

  belongs_to :campaign

  private
  def sanitize_phone_number
    unless self.phone_number.nil?
      self.phone_number = self.phone_number.gsub('-', '').gsub('(', '').gsub(')', '').gsub('+', '') # (123)-123-1234
    end
  end
end
