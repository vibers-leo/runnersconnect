class ExternalRace < ApplicationRecord
  enum :status, { active: 0, cancelled: 1, completed: 2 }

  validates :title, presence: { message: "대회명을 입력해주세요" }
  validates :source_url, presence: true, uniqueness: true
  validates :race_date, presence: { message: "대회 날짜를 입력해주세요" }
  validates :source_name, presence: true

  scope :upcoming, -> { where("race_date >= ?", Date.current).order(race_date: :asc) }
  scope :past, -> { where("race_date < ?", Date.current).order(race_date: :desc) }
  scope :from_source, ->(name) { where(source_name: name) if name.present? }
  scope :by_month, ->(year, month) {
    start_date = Date.new(year.to_i, month.to_i, 1)
    end_date = start_date.end_of_month
    where(race_date: start_date..end_date)
  }
  scope :search_by_title, ->(query) { where("title ILIKE ?", "%#{query}%") if query.present? }

  def past?
    race_date < Date.current
  end

  def external?
    true
  end

  def multi_day?
    race_end_date.present? && race_end_date != race_date
  end

  def date_display
    if multi_day?
      "#{race_date.strftime('%Y.%m.%d')} ~ #{race_end_date.strftime('%m.%d')}"
    else
      race_date.strftime("%Y.%m.%d")
    end
  end
end
