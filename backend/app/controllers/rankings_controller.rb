class RankingsController < ApplicationController
  def index
    users = User.where("total_distance > 0")
                .order(total_distance: :desc)
                .limit(20)

    @rankings = users.map do |user|
      {
        name: user.name,
        distance: "#{user.total_distance.round(1)}km",
        count: user.total_races,
        pace: calculate_average_pace(user)
      }
    end
  end

  private

  def calculate_average_pace(user)
    records = user.records.joins(:race_edition)
                  .where("race_editions.distance > 0")
                  .where.not(net_time: nil)
                  .pluck("records.net_time", "race_editions.distance")

    return "N/A" if records.empty?

    total_seconds = 0
    total_km = 0.0
    records.each do |net_time, distance|
      parts = net_time.split(":").map(&:to_i)
      seconds = parts[0] * 3600 + parts[1] * 60 + (parts[2] || 0)
      total_seconds += seconds
      total_km += distance
    end

    return "N/A" if total_km.zero?
    pace_seconds = (total_seconds / total_km).round
    minutes = pace_seconds / 60
    secs = pace_seconds % 60
    "#{minutes}'#{format('%02d', secs)}\""
  end
end
