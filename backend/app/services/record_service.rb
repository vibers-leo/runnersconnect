class RecordService
  def self.create(user:, race_edition:, net_time:)
    record = Record.new(user: user, race_edition: race_edition, net_time: net_time)
    if record.save
      { success: true, record: record }
    else
      { success: false, errors: record.errors.full_messages }
    end
  end

  def self.verify(record)
    record.update!(is_verified: true)
    { success: true }
  end
end
