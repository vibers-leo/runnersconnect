class RegistrationSerializer
  include JSONAPI::Serializer
  attributes :id, :status, :bib_number, :payment_amount, :payment_method,
             :merchant_uid, :qr_token, :created_at

  belongs_to :race_edition, serializer: RaceEditionSerializer
end
