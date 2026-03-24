class RaceEditionSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :distance, :price, :capacity, :current_count
end
