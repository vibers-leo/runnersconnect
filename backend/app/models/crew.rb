class Crew < ApplicationRecord
  belongs_to :leader, class_name: "User"
  has_many :crew_contact_points, dependent: :destroy
  has_many :registrations
  has_many :members, through: :registrations, source: :user

  has_one_attached :logo
  has_one_attached :cover_image
  has_many_attached :activity_photos

  accepts_nested_attributes_for :crew_contact_points,
    allow_destroy: true,
    reject_if: :all_blank

  # Enums
  enum :status, { draft: 0, pending_review: 1, published: 2, suspended: 3 }

  # Validations
  validates :name, presence: { message: "크루 이름을 입력해주세요" }
  validates :name, uniqueness: { message: "이미 사용 중인 크루 이름입니다" }, if: -> { name.present? }
  validates :slug, uniqueness: true, allow_nil: true
  validates :code, presence: true, uniqueness: true
  validates :short_description, length: { maximum: 100, message: "한 줄 소개는 100자 이내로 작성해주세요" }
  validates :description, presence: { message: "크루 소개를 작성해주세요" }, if: :pending_review?
  validates :region, inclusion: {
    in: %w[서울 부산 대구 인천 광주 대전 울산 세종 경기 강원 충북 충남 전북 전남 경북 경남 제주],
    message: "유효한 지역을 선택해주세요"
  }, allow_blank: true

  # Scopes
  scope :visible, -> { where(status: :published) }
  scope :featured, -> { visible.where(featured: true) }
  scope :by_region, ->(region) { where(region: region) if region.present? }
  scope :recent, -> { order(published_at: :desc) }
  scope :popular, -> { order(views_count: :desc) }
  scope :search_by_name, ->(query) { where("name ILIKE ? OR short_description ILIKE ?", "%#{query}%", "%#{query}%") if query.present? }

  # Callbacks
  before_validation :generate_unique_code, on: :create
  before_validation :generate_slug, on: :create

  def publish!
    update!(status: :published, published_at: Time.current)
  end

  def suspend!
    update!(status: :suspended)
  end

  def increment_views!
    increment!(:views_count)
  end

  def primary_contact
    crew_contact_points.find_by(primary: true) || crew_contact_points.first
  end

  def status_badge_color
    case status
    when "draft" then "bg-gray-100 text-gray-600"
    when "pending_review" then "bg-yellow-100 text-yellow-700"
    when "published" then "bg-green-100 text-green-700"
    when "suspended" then "bg-red-100 text-red-700"
    end
  end

  def status_display
    case status
    when "draft" then "임시저장"
    when "pending_review" then "검토 대기"
    when "published" then "공개"
    when "suspended" then "정지"
    end
  end

  private

  def generate_unique_code
    self.code ||= SecureRandom.alphanumeric(8).upcase
  end

  def generate_slug
    return if slug.present? || name.blank?
    base_slug = name.parameterize(separator: "-")
    base_slug = SecureRandom.hex(4) if base_slug.blank?
    self.slug = base_slug
    counter = 1
    while Crew.exists?(slug: self.slug)
      self.slug = "#{base_slug}-#{counter}"
      counter += 1
    end
  end
end
