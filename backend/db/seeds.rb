# Clear existing data safely
puts "🧹 Clearing existing data..."

begin
  Record.destroy_all
  puts "  ✓ Records cleared"
rescue => e
  puts "  ⚠ Error destroying records: #{e.message}"
end

begin
  Registration.destroy_all
  puts "  ✓ Registrations cleared"
rescue => e
  puts "  ⚠ Error destroying registrations: #{e.message}"
end

begin
  RaceEdition.destroy_all
  puts "  ✓ Race editions cleared"
rescue => e
  puts "  ✓ Error destroying race editions: #{e.message}"
end

begin
  Race.destroy_all
  puts "  ✓ Races cleared"
rescue => e
  puts "  ⚠ Error destroying races: #{e.message}"
end

begin
  OrganizerProfile.destroy_all
  puts "  ✓ Organizer profiles cleared"
rescue => e
  puts "  ⚠ Error destroying organizer profiles: #{e.message}"
end

begin
  User.where(role: ['organizer', 'admin']).destroy_all
  puts "  ✓ Admin/Organizer users cleared"
rescue => e
  puts "  ⚠ Error destroying users: #{e.message}"
end

puts "\n👤 Creating users..."

# Create Admin User
admin = User.create!(
  email: 'admin@runnersconnect.com',
  password: 'password123',
  password_confirmation: 'password123',
  name: '관리자',
  phone_number: '010-0000-0000',
  role: 'admin',
  gender: 'male',
  birth_date: Date.new(1985, 5, 15),
  age_group: '30대'
)
puts "  ✓ Admin created: #{admin.email}"

# Create Organizer User
organizer_user = User.create!(
  email: 'organizer@seoul-marathon.com',
  password: 'password123',
  password_confirmation: 'password123',
  name: '김주최',
  phone_number: '010-1234-5678',
  role: 'organizer',
  gender: 'male',
  birth_date: Date.new(1980, 3, 20),
  age_group: '40대'
)
puts "  ✓ Organizer user created: #{organizer_user.email}"

# Create OrganizerProfile
organizer_profile = OrganizerProfile.create!(
  user: organizer_user,
  business_name: '서울마라톤조직위원회',
  contact_email: 'contact@seoul-marathon.com',
  contact_phone: '02-1234-5678',
  description: '서울시에서 주관하는 대한민국 대표 마라톤 대회를 운영하고 있습니다.',
  bank_name: '국민은행',
  bank_account: '123-456-789012',
  account_holder: '김주최',
  total_races_count: 0,
  total_participants_count: 0
)
puts "  ✓ Organizer profile created: #{organizer_profile.business_name}"

# Create another Organizer User
organizer_user2 = User.create!(
  email: 'organizer@busan-marathon.com',
  password: 'password123',
  password_confirmation: 'password123',
  name: '박대회',
  phone_number: '010-8765-4321',
  role: 'organizer',
  gender: 'female',
  birth_date: Date.new(1982, 7, 10),
  age_group: '40대'
)
puts "  ✓ Second organizer user created: #{organizer_user2.email}"

organizer_profile2 = OrganizerProfile.create!(
  user: organizer_user2,
  business_name: '부산일보 마라톤팀',
  contact_email: 'contact@busan-marathon.com',
  contact_phone: '051-1234-5678',
  description: '부산 지역 최고의 마라톤 대회를 개최합니다.',
  bank_name: '신한은행',
  bank_account: '987-654-321098',
  account_holder: '박대회'
)
puts "  ✓ Second organizer profile created: #{organizer_profile2.business_name}"

# Create Blossom Running Organizer (벚꽃러닝 - Pilot Test Target)
blossom_user = User.create!(
  email: 'blossom@blossomrunning.com',
  password: 'password123',
  password_confirmation: 'password123',
  name: '최벚꽃',
  phone_number: '010-2024-0330',
  role: 'organizer',
  gender: 'female',
  birth_date: Date.new(1990, 3, 30),
  age_group: '30대'
)
puts "  ✓ Blossom Running organizer created: #{blossom_user.email}"

blossom_profile = OrganizerProfile.create!(
  user: blossom_user,
  business_name: '벚꽃러닝 커뮤니티',
  contact_email: 'contact@blossomrunning.com',
  contact_phone: '02-2024-0330',
  description: '벚꽃이 만개하는 봄날, 함께 달리는 즐거움을 나누는 러닝 커뮤니티입니다. 매년 봄 여의도 윤중로에서 특별한 벚꽃 마라톤을 개최합니다.',
  bank_name: '카카오뱅크',
  bank_account: '3333-01-1234567',
  account_holder: '최벚꽃'
)
puts "  ✓ Blossom Running profile created: #{blossom_profile.business_name}"

# Create Test Participants
participants = []
korean_surnames = ['김', '이', '박', '최', '정', '강', '조', '윤', '장', '임', '한', '오', '서', '신', '권', '황', '안', '송', '전', '홍']
korean_given_names = ['민준', '서준', '도윤', '예준', '시우', '주원', '하준', '지호', '지우', '준서',
                      '서연', '서윤', '지우', '서현', '민서', '하은', '지민', '지안', '수아', '윤서']

100.times do |i|
  birth_year = rand(1970..2005)
  age_group = case birth_year
  when 2010..2015 then '10대'
  when 1995..2009 then '20대'
  when 1985..1994 then '30대'
  when 1975..1984 then '40대'
  when 1965..1974 then '50대'
  else '60대이상'
  end

  surname = korean_surnames.sample
  given_name = korean_given_names.sample
  full_name = "#{surname}#{given_name}"

  participant = User.create!(
    email: "runner#{i+1}@example.com",
    password: 'password123',
    password_confirmation: 'password123',
    name: full_name,
    phone_number: "010-#{rand(1000..9999)}-#{rand(1000..9999)}",
    role: 'user',
    gender: ['male', 'female'].sample,
    birth_date: Date.new(birth_year, rand(1..12), rand(1..28)),
    age_group: age_group
  )
  participants << participant
end
puts "  ✓ Created #{participants.count} test participants"

puts "\n🏃 Creating races..."

# Create Seoul Marathon (for first organizer)
seoul_marathon = Race.create!(
  title: "2026 서울 국제 마라톤",
  description: "서울 도심을 가로지르는 대한민국 최고의 마라톤 축제에 여러분을 초대합니다. 광화문 광장에서 출발하여 잠실 종합운동장까지 이어지는 코스는 평탄하고 기록 달성에 최적화되어 있습니다. 3만 명의 러너들과 함께 서울의 봄을 만끽하세요!",
  location: "서울 광화문 광장",
  start_at: 1.month.from_now,
  organizer: organizer_profile,
  status: :open,
  registration_start_at: 1.month.ago,
  registration_end_at: 1.week.from_now,
  is_official_record: true
)
puts "  ✓ Seoul Marathon created"

# Create Editions for Seoul Marathon
full_course = seoul_marathon.race_editions.create!(
  name: "풀코스 (42.195km)",
  distance: 42.195,
  price: 50000,
  capacity: 10000
)
puts "    - Full course edition created"

half_course = seoul_marathon.race_editions.create!(
  name: "하프코스 (21.0975km)",
  distance: 21.0975,
  price: 40000,
  capacity: 8000
)
puts "    - Half course edition created"

ten_k = seoul_marathon.race_editions.create!(
  name: "10K 코스 (10km)",
  distance: 10.0,
  price: 30000,
  capacity: 15000
)
puts "    - 10K course edition created"

# Create Busan Marathon (for second organizer)
busan_marathon = Race.create!(
  title: "2026 부산 바다 마라톤",
  description: "광안대교 위를 달리는 환상적인 경험! 부산의 바다와 함께 달리는 특별한 레이스입니다.",
  location: "부산 벡스코",
  start_at: 2.months.from_now,
  organizer: organizer_profile2,
  status: :open,
  registration_start_at: 1.month.ago,
  registration_end_at: 2.weeks.from_now,
  is_official_record: false
)
puts "  ✓ Busan Marathon created"

busan_half = busan_marathon.race_editions.create!(
  name: "하프코스 (21.0975km)",
  distance: 21.0975,
  price: 40000,
  capacity: 5000
)
puts "    - Busan half course edition created"

# Create Blossom Running Race (벚꽃러닝 - Pilot Test)
blossom_race = Race.create!(
  title: "2026 여의도 벚꽃 러닝 페스티벌",
  description: "벚꽃이 만개하는 여의도 윤중로에서 펼쳐지는 봄날의 러닝 축제! 약 1,600그루의 벚나무 터널을 달리며 봄의 낭만을 만끽하세요. 완주 후에는 벚꽃 피크닉과 함께 특별한 추억을 만들어가세요.",
  location: "여의도 한강공원 윤중로",
  start_at: 3.weeks.from_now,
  organizer: blossom_profile,
  status: :open,
  registration_start_at: 2.weeks.ago,
  registration_end_at: 2.weeks.from_now,
  is_official_record: false
)
puts "  ✓ Blossom Running Race created"

blossom_10k = blossom_race.race_editions.create!(
  name: "벚꽃 10K 코스",
  distance: 10.0,
  price: 35000,
  capacity: 500
)
puts "    - Blossom 10K course created"

blossom_5k = blossom_race.race_editions.create!(
  name: "벚꽃 5K 코스",
  distance: 5.0,
  price: 25000,
  capacity: 300
)
puts "    - Blossom 5K course created"

puts "\n📝 Creating registrations..."

# Create registrations for Seoul Marathon
editions = [full_course, half_course, ten_k]
participants.each_with_index do |participant, index|
  edition = editions[index % 3]

  timestamp = (20 - index).days.ago.to_i
  merchant_uid = "REG#{timestamp}#{rand(1000..9999)}"

  registration = Registration.create!(
    user: participant,
    race: seoul_marathon,
    race_edition: edition,
    status: 'paid',
    payment_amount: edition.price,
    merchant_uid: merchant_uid,
    bib_number: index + 1,
    shipping_address: "서울시 강남구 테헤란로 #{100 + index}",
    created_at: (20 - index).days.ago
  )

  # Mark some souvenirs as received (first 10)
  if index < 10
    registration.update!(
      souvenir_received_at: index.days.ago,
      souvenir_received_by: '김스태프'
    )
  end

  # Mark some medals as received (first 7)
  if index < 7
    registration.update!(
      medal_received_at: index.days.ago,
      medal_received_by: index.even? ? '김스태프' : '이스태프'
    )
  end

  # Create records for some participants (first 5)
  if index < 5
    completion_seconds = case edition.distance
    when 42.195
      rand(7200..14400) # 2-4 hours for full marathon
    when 21.0975
      rand(4500..9000)  # 1.25-2.5 hours for half
    else
      rand(2400..4800)  # 40-80 minutes for 10K
    end

    # Convert seconds to HH:MM:SS format
    hours = completion_seconds / 3600
    minutes = (completion_seconds % 3600) / 60
    seconds = completion_seconds % 60
    net_time = format('%02d:%02d:%02d', hours, minutes, seconds)

    Record.create!(
      user: participant,
      race_edition: edition,
      registration: registration,
      net_time: net_time,
      gun_time: net_time
    )
  end
end

puts "  ✓ Created #{Registration.count} registrations for Seoul Marathon"
puts "  ✓ Created #{Record.count} completion records"

# Create registrations for Blossom Running (50 participants)
puts "\n📝 Creating registrations for Blossom Running..."
blossom_editions = [blossom_10k, blossom_5k]
participants[20..69].each_with_index do |participant, index|
  edition = blossom_editions[index % 2]

  timestamp = (15 - (index % 15)).days.ago.to_i
  merchant_uid = "BLOSSOM#{timestamp}#{rand(1000..9999)}"

  registration = Registration.create!(
    user: participant,
    race: blossom_race,
    race_edition: edition,
    status: 'paid',
    payment_amount: edition.price,
    merchant_uid: merchant_uid,
    bib_number: index + 1,
    shipping_address: "서울시 영등포구 여의도동 #{10 + index}",
    created_at: (15 - (index % 15)).days.ago
  )

  # Mark souvenirs as received (random)
  if rand < 0.6
    registration.update!(
      souvenir_received_at: rand(1..5).days.ago,
      souvenir_received_by: ['최벚꽃', '김스태프', '이도우미'].sample
    )
  end

  # Create records for half of participants (simulating race has finished)
  if index < 25
    completion_seconds = case edition.distance
    when 10.0
      rand(2400..4200) # 40-70 minutes for 10K
    else
      rand(1200..2400) # 20-40 minutes for 5K
    end

    hours = completion_seconds / 3600
    minutes = (completion_seconds % 3600) / 60
    seconds = completion_seconds % 60
    net_time = format('%02d:%02d:%02d', hours, minutes, seconds)

    Record.create!(
      user: participant,
      race_edition: edition,
      registration: registration,
      net_time: net_time,
      gun_time: net_time
    )
  end
end
puts "  ✓ Created 50 registrations for Blossom Running"
puts "  ✓ Created 25 completion records for Blossom Running"

# Update organizer statistics
organizer_profile.update!(
  total_races_count: organizer_profile.races.count,
  total_participants_count: Registration.joins(:race).where(races: { organizer_id: organizer_profile.id }, status: 'paid').count
)

organizer_profile2.update!(
  total_races_count: organizer_profile2.races.count,
  total_participants_count: Registration.joins(:race).where(races: { organizer_id: organizer_profile2.id }, status: 'paid').count
)

blossom_profile.update!(
  total_races_count: blossom_profile.races.count,
  total_participants_count: Registration.joins(:race).where(races: { organizer_id: blossom_profile.id }, status: 'paid').count
)

puts "\n🛍️ Creating products (goods)..."

# Products for Seoul Marathon
seoul_tshirt = seoul_marathon.products.create!(
  name: "서울마라톤 기념 티셔츠",
  description: "2026 서울 국제 마라톤 공식 기념 티셔츠입니다. 고급 기능성 원단으로 제작되었습니다.",
  price: 35000,
  stock: 100,
  status: 'active',
  size: 'M',
  color: '블랙'
)
puts "  ✓ Seoul Marathon T-shirt created"

seoul_cap = seoul_marathon.products.create!(
  name: "서울마라톤 러닝 캡",
  description: "통기성이 우수한 메쉬 소재의 러닝 캡입니다.",
  price: 25000,
  stock: 50,
  status: 'active',
  color: '화이트'
)
puts "  ✓ Seoul Marathon cap created"

# Products for Blossom Running
blossom_tshirt = blossom_race.products.create!(
  name: "벚꽃러닝 한정판 티셔츠",
  description: "벚꽃 패턴이 프린팅된 2026 여의도 벚꽃러닝 한정판 티셔츠입니다. 수량 한정!",
  price: 30000,
  stock: 80,
  status: 'active',
  size: 'L',
  color: '핑크'
)
puts "  ✓ Blossom Running T-shirt created"

blossom_tumbler = blossom_race.products.create!(
  name: "벚꽃러닝 텀블러",
  description: "벚꽃 디자인의 스테인리스 텀블러입니다. 500ml 용량.",
  price: 20000,
  stock: 60,
  status: 'active'
)
puts "  ✓ Blossom Running tumbler created"

blossom_bag = blossom_race.products.create!(
  name: "벚꽃러닝 에코백",
  description: "친환경 소재의 벚꽃 패턴 에코백입니다.",
  price: 15000,
  stock: 100,
  status: 'active'
)
puts "  ✓ Blossom Running eco bag created"

puts "\n🛒 Creating sample orders..."

# Create some orders for Blossom Running
5.times do |i|
  customer = participants[70 + i]

  order = Order.create!(
    user: customer,
    race: blossom_race,
    order_number: "ORD#{Time.current.to_i + i}#{rand(1000..9999)}",
    status: i < 3 ? 'paid' : 'pending',
    shipping_address: "서울시 영등포구 여의도동 #{100 + i}",
    shipping_phone: customer.phone_number,
    total_amount: 0
  )

  # Add 2-3 random products to each order
  rand(2..3).times do
    product = [blossom_tshirt, blossom_tumbler, blossom_bag].sample
    quantity = rand(1..2)

    OrderItem.create!(
      order: order,
      product: product,
      quantity: quantity,
      unit_price: product.price,
      subtotal: product.price * quantity
    )
  end

  # Update order total
  order.update!(total_amount: order.order_items.sum(:subtotal))
end
puts "  ✓ Created 5 sample orders"

puts "\n💰 Creating settlements..."

# Create settlement for Seoul Marathon
seoul_settlement = Settlement.create!(
  organizer_profile: organizer_profile,
  race: seoul_marathon,
  status: 'pending',
  registration_count: 0,
  total_revenue: 0,
  platform_commission: 0,
  organizer_payout: 0
)
seoul_settlement.calculate!
puts "  ✓ Seoul Marathon settlement created (#{seoul_settlement.organizer_payout}원)"

# Create settlement for Blossom Running
blossom_settlement = Settlement.create!(
  organizer_profile: blossom_profile,
  race: blossom_race,
  status: 'pending',
  registration_count: 0,
  total_revenue: 0,
  platform_commission: 0,
  organizer_payout: 0
)
blossom_settlement.calculate!
puts "  ✓ Blossom Running settlement created (#{blossom_settlement.organizer_payout}원)"

puts "\n🕷️ Creating crawl sources..."

crawl_sources = [
  {
    name: "마라톤온라인",
    base_url: "http://marathon.pe.kr",
    crawler_class: "Crawlers::MarathonPeKrCrawler",
    enabled: true,
    crawl_interval_hours: 6
  },
  {
    name: "대한육상연맹",
    base_url: "https://www.athletics.or.kr",
    crawler_class: "Crawlers::AthleticsOrKrCrawler",
    enabled: true,
    crawl_interval_hours: 12
  },
  {
    name: "Runpia",
    base_url: "https://runpia.co.kr",
    crawler_class: "Crawlers::RunpiaCrawler",
    enabled: true,
    crawl_interval_hours: 6
  },
  {
    name: "스포츠포털",
    base_url: "https://www.sportal.or.kr",
    crawler_class: "Crawlers::SportalKoreaCrawler",
    enabled: true,
    crawl_interval_hours: 12
  },
  {
    name: "네이버카페-크루모집",
    base_url: "https://openapi.naver.com",
    crawler_class: "Crawlers::NaverRunningCrewCrawler",
    enabled: false,  # NAVER_CLIENT_ID/SECRET 환경변수 설정 후 활성화
    crawl_interval_hours: 24
  }
]

crawl_sources.each do |attrs|
  source = CrawlSource.find_or_initialize_by(crawler_class: attrs[:crawler_class])
  source.assign_attributes(attrs)
  source.save!
  puts "  ✓ #{attrs[:name]} (#{attrs[:enabled] ? '활성' : '비활성'})"
end

puts "\n✅ Seed data created successfully!"
puts "\n📊 Summary:"
puts "  - Users: #{User.count} (#{User.where(role: 'admin').count} admin, #{User.where(role: 'organizer').count} organizers, #{User.where(role: 'user').count} participants)"
puts "  - Organizer Profiles: #{OrganizerProfile.count}"
puts "  - Races: #{Race.count}"
puts "  - Race Editions: #{RaceEdition.count}"
puts "  - Registrations: #{Registration.count} (#{Registration.where(status: 'paid').count} paid)"
puts "  - Souvenir received: #{Registration.where.not(souvenir_received_at: nil).count}"
puts "  - Medal received: #{Registration.where.not(medal_received_at: nil).count}"
puts "  - Records: #{Record.count}"
puts "  - Products: #{Product.count}"
puts "  - Orders: #{Order.count} (#{Order.where(status: 'paid').count} paid)"
puts "  - Settlements: #{Settlement.count}"
puts "\n🔐 Test Accounts:"
puts "  Admin: admin@runnersconnect.com / password123"
puts "  Organizer 1: organizer@seoul-marathon.com / password123 (서울마라톤)"
puts "  Organizer 2: organizer@busan-marathon.com / password123 (부산마라톤)"
puts "  🌸 Organizer 3 (Pilot): blossom@blossomrunning.com / password123 (벚꽃러닝)"
puts "  Participants: runner1@example.com ~ runner100@example.com / password123"
puts "\n🎯 Pilot Test Focus:"
puts "  - Blossom Running Race: 50 registrations, 25 records, 5 product types, 5 orders"
puts "  - Settlement pending: #{blossom_settlement.organizer_payout}원"
