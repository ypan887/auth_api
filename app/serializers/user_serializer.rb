class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :nickname, :provider, :uid
end