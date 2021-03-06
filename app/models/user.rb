class User < ApplicationRecord
  @@POSITIONS = ['', 'Candidate', 'Chair', 'Treasurer', 'Other PAC Officer']

  before_validation :sanitize_phone_number

  validate :superuser_attributes
  validate :position_info
  validates :phone_number, number: true

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  belongs_to :campaign, required: false

  def self.POSITIONS
    @@POSITIONS
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
        errors.add(:superuser, 'is immutable')

        self.reload
      end

      if self.changed.include?('campaign_id') && !self.superuser && !self.campaign_id_was.nil?
        errors.add(:campaign_id, 'is immutable')

        self.reload
      end
    end
  end

  def position_info
    if self.position.nil? || self.position.empty?
      return
    end

    if User.where( :campaign_id => campaign_id ).where.not( :id => id ).map { |user| user.position }.include? position
      errors.add(:position, 'has already been filled')

      return
    end

    unless !self.created
      if self.middle_name.nil? || self.middle_name.empty?
        errors.add(:middle_name, 'position requires middle name')
      end

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

      if self.zipcode.nil? || self.zipcode.empty?
        errors.add(:zipcode, 'position requires zipcode')
      end

      if self.phone_number.nil? || self.phone_number.empty?
        errors.add(:phone_number, 'position requires phone_number')
      end

      if self.party.nil? || self.party.empty?
        errors.add(:party, 'position requires party')
      end
    end
  end
end
