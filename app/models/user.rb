class User < ApplicationRecord
  @@POSITIONS = ['', 'Candidate', 'Chairman', 'Treasurer']
  @@COMMITTEE_POSITIONS = ['Candidate', 'Chairman', 'Treasurer']

  before_validation :sanitize_phone_number

  validate :superuser_attributes
  validate :position_info
  validates :position, position: true
  validates :phone_number, number: true

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  belongs_to :campaign

  def self.POSITIONS
    @@POSITIONS
  end

  def self.COMMITTEE_POSITIONS
    @@COMMITTEE_POSITIONS
  end

  def reset_password_token
    set_reset_password_token
  end

  def as_json(options = {})
    ActiveModelSerializers::SerializableResource.new(
      self,
      serializer: UserSerializer,
      key_transform: :camel_lower
    ).as_json
  end

  private
  def sanitize_phone_number
    unless self.phone_number.nil?
      self.phone_number = self.phone_number.gsub('-', '').gsub('(', '').gsub(')', '').gsub('+', '') # (123)-123-1234
    end
  end

  def superuser_attributes
    if self.persisted?
      if self.changed.include?('superuser')
        errors.add(:superuser, :immutable)

        self.reload
      end

      if self.changed.include?('campaign_id') && !self.superuser
        errors.add(:campaign_id, :immutable)

        self.reload
      end
    end
  end

  def position_info
    if @@COMMITTEE_POSITIONS.include? self.position
      if self.address.nil? || self.address.empty?
        errors.add(:address, 'position requires address')
      end

      if self.city.nil? || self.city.empty?
        errors.add(:city, 'position requires city')
      end

      if self.state.nil? || self.state.empty?
        errors.add(:state, 'position requires state')
      end

      if self.country.nil? || self.country.empty?
        errors.add(:country, 'position requires country')
      end

      if self.phone_number.nil? || self.phone_number.empty?
        errors.add(:phone_number, 'position requires phone_number')
      end
    end
  end
end
