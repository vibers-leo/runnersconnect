class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # Associations
  has_many :registrations
  has_many :records
  has_many :led_crews, class_name: 'Crew', foreign_key: 'leader_id'
  has_one :organizer_profile, dependent: :destroy
  has_many :organized_races, through: :organizer_profile, source: :races
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :medium, resize_to_limit: [300, 300]
  end

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :nickname, uniqueness: true, allow_nil: true
  validates :nickname, format: { with: /\A[가-힣a-zA-Z0-9_]+\z/, message: "한글, 영문, 숫자, 언더스코어만 사용 가능합니다" }, allow_nil: true, if: -> { nickname.present? }
  validates :region, inclusion: { in: %w[서울 부산 대구 인천 광주 대전 울산 세종 경기 강원 충북 충남 전북 전남 경북 경남 제주], message: "유효한 지역을 선택해주세요" }, allow_nil: true, if: -> { region.present? }
  validates :age_group, inclusion: { in: %w[10대 20대 30대 40대 50대 60대이상], message: "유효한 연령대를 선택해주세요" }, allow_nil: true, if: -> { age_group.present? }
  validate :avatar_size
  
  # Roles
  enum :role, { user: 'user', staff: 'staff', admin: 'admin', organizer: 'organizer' }, default: 'user'

  def admin?
    role == 'admin'
  end

  def organizer?
    role == 'organizer'
  end

  def display_name
    nickname.presence || name
  end

  def avatar_url
    return nil unless avatar.attached?
    Rails.application.routes.url_helpers.rails_blob_url(avatar, only_path: true)
  end

  # Cart helper
  def current_cart
    cart || create_cart
  end

  private

  def avatar_size
    return unless avatar.attached?
    if avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, "파일 크기는 5MB 이하여야 합니다")
    end
  end
end
