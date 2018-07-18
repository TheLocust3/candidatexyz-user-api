class UserSerializer < ActiveModel::Serializer
  attributes :id, :campaign_id, :email, :first_name, :last_name, :admin, :superuser, :position, :address, :city, :state, :country, :zipcode, :phone_number, :party
end
