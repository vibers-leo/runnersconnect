module PosterAnalysis
  class Result
    attr_reader :success, :data, :raw_text, :error

    def initialize(success:, data: nil, raw_text: nil, error: nil)
      @success = success
      @data = data
      @raw_text = raw_text
      @error = error
    end

    def success?
      @success
    end
  end
end
