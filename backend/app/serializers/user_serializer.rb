class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :name, :role, :total_distance, :total_races, :preferred_size
end
