class User < ApplicationRecord
  validate :superuser_attributes

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  belongs_to :campaign

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
end
