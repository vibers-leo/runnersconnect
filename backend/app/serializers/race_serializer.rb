class RaceSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :description, :location, :start_at,
             :registration_start_at, :registration_end_at, :status,
             :thumbnail_url, :organizer_name

  attribute :organizer_name do |race|
    race.organizer&.business_name || race.organizer&.user&.name
  end

  attribute :thumbnail_url do |race|
    race.thumbnail_url
  end

  has_many :race_editions, serializer: RaceEditionSerializer
end
