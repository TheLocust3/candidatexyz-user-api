class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  def as_json(options)
    ActiveModelSerializers::SerializableResource.new(
      self,
      serializer: UserSerializer,
      key_transform: :camel_lower
    ).as_json
  end
end
