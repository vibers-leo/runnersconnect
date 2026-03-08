class CrewContactPoint < ApplicationRecord
  belongs_to :crew

  enum :platform, {
    instagram: 0,
    kakao_openchat: 1,
    naver_cafe: 2,
    website: 3,
    other: 4
  }

  validates :platform, presence: { message: "플랫폼을 선택해주세요" }
  validates :url, presence: { message: "URL 또는 링크를 입력해주세요" }
  validates :label, presence: { message: "표시 이름을 입력해주세요" }

  def icon_name
    case platform
    when "instagram" then "instagram"
    when "kakao_openchat" then "kakao"
    when "naver_cafe" then "naver"
    when "website" then "globe"
    else "link"
    end
  end

  def platform_display_name
    case platform
    when "instagram" then "인스타그램"
    when "kakao_openchat" then "카카오톡 오픈채팅"
    when "naver_cafe" then "네이버 카페"
    when "website" then "웹사이트"
    else "기타"
    end
  end

  def platform_color
    case platform
    when "instagram" then "from-purple-500 to-pink-500"
    when "kakao_openchat" then "from-yellow-400 to-yellow-500"
    when "naver_cafe" then "from-green-500 to-green-600"
    when "website" then "from-blue-500 to-blue-600"
    else "from-gray-500 to-gray-600"
    end
  end
end
