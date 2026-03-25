begin
  puts "Cleaning up..."
  Record.destroy_all
  Registration.destroy_all
  Crew.destroy_all
  RaceEdition.destroy_all
  Race.destroy_all

  puts "Creating Race..."
  race = Race.create!(
    title: "2026 서울 도심 나이트런",
    description: "서울의 아름다운 야경과 함께 달리는 특별한 경험! 광화문에서 출발해 한강공원까지 이어지는 환상적인 코스.",
    location: "광화문 광장",
    start_at: 2.months.from_now,
    organizer_name: "러닝크루연합",
    status: :open,
    registration_start_at: 1.week.ago,
    registration_end_at: 1.week.from_now,
    is_official_record: false
  )

  puts "Creating Editions..."
  race.race_editions.create!(
    name: "10K Challenge",
    price: 35000,
    capacity: 2000
  )
  race.race_editions.create!(
    name: "5K Fun Run",
    price: 25000,
    capacity: 3000
  )

  puts "Seed data for testing created!"
rescue => e
  puts "ERROR: #{e.message}"
  puts e.backtrace.join("\n")
end
