require 'rtesseract'
require 'mini_magick'

module PosterAnalysis
  class TesseractAnalyzer
    def initialize(image_path)
      @image_path = image_path
    end

    def analyze
      # 1. 이미지 전처리 (contrast, grayscale)
      preprocessed = preprocess_image

      # 2. OCR 실행 (한국어 + 영어)
      text = extract_text(preprocessed)

      # 3. 파싱
      parsed_data = parse_text(text)

      Result.new(
        success: true,
        raw_text: text,
        data: parsed_data
      )
    rescue => e
      Result.new(success: false, error: e.message)
    end

    private

    def preprocess_image
      # MiniMagick으로 이미지 전처리
      # - Grayscale 변환
      # - Contrast 향상
      # - Noise 제거
      image = MiniMagick::Image.open(@image_path)
      image.colorspace("Gray")
      image.contrast
      image.path
    end

    def extract_text(image_path)
      # Tesseract OCR 실행
      RTesseract.new(image_path, lang: 'kor+eng').to_s
    rescue => e
      Rails.logger.error "Tesseract OCR failed: #{e.message}"
      raise "OCR 실행에 실패했습니다. Tesseract가 설치되어 있는지 확인해주세요."
    end

    def parse_text(text)
      Parsers::RaceInfoParser.new(text).parse
    end
  end
end
