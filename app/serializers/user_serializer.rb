class UserSerializer < ActiveModel::Serializer
  attributes :id, :campaign_id, :email, :first_name, :last_name, :admin, :superuser
end
