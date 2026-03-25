begin
  puts "Creating Race..."
  race = Race.create!(
    title: "Test Race",
    start_at: Time.current + 1.month,
    location: "Test Location",
    status: :open
  )
  puts "Race created: #{race.id}"

  puts "Creating Edition..."
  edition = race.race_editions.create!(
    name: "10K",
    distance: 10,
    price: 10000,
    capacity: 100
  )
  puts "Edition created: #{edition.id}"

  puts "Cleanup..."
  race.destroy!
  puts "Done."
rescue => e
  puts "ERROR: #{e.message}"
  puts e.backtrace.join("\n")
end
