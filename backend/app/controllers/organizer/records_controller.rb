class Organizer::RecordsController < Organizer::BaseController
  before_action :set_race
  before_action :authorize_race_access!

  def index
    @records = Record.joins(:registration)
                     .where(registrations: { race_id: @race.id })
                     .includes(:user, :race_edition, :registration)
                     .order('records.net_time ASC')

    @completion_rate = @race.registrations.where(status: 'paid').count > 0 ?
      (@records.count.to_f / @race.registrations.where(status: 'paid').count * 100).round(1) : 0
  end

  def upload_form
    # 기록 업로드 폼
  end

  def bulk_upload
    file = params[:records_file]

    unless file.present?
      flash[:error] = '파일을 선택해주세요.'
      redirect_to upload_form_organizer_race_records_path(@race)
      return
    end

    # CSV 인코딩 자동 감지 및 변환
    begin
      csv_text = detect_and_convert_encoding(file.read)
    rescue => e
      flash[:error] = "CSV 파일 읽기 실패: #{e.message}. UTF-8, EUC-KR, CP949 인코딩을 지원합니다."
      redirect_to upload_form_organizer_race_records_path(@race)
      return
    end

    # CSV 파싱
    begin
      csv = CSV.parse(csv_text, headers: true)
    rescue CSV::MalformedCSVError => e
      flash[:error] = "CSV 형식 오류: #{e.message}. 올바른 CSV 파일인지 확인해주세요."
      redirect_to upload_form_organizer_race_records_path(@race)
      return
    end

    # 헤더 검증
    unless csv.headers&.include?('등번호')
      flash[:error] = "CSV 파일에 '등번호' 컬럼이 없습니다. 샘플 파일을 참고해주세요."
      redirect_to upload_form_organizer_race_records_path(@race)
      return
    end

    unless csv.headers&.include?('완주 시간') || csv.headers&.include?('기록')
      flash[:error] = "CSV 파일에 '완주 시간' 또는 '기록' 컬럼이 없습니다. 샘플 파일을 참고해주세요."
      redirect_to upload_form_organizer_race_records_path(@race)
      return
    end

    success_records = []
    updated_records = []
    error_records = []

    csv.each_with_index do |row, index|
      line_number = index + 2  # 헤더 제외한 실제 행 번호

      bib_number = row['등번호']&.strip
      net_time_str = row['완주 시간']&.strip || row['기록']&.strip

      # 빈 값 체크
      unless bib_number.present? && net_time_str.present?
        error_records << {
          line: line_number,
          bib_number: bib_number || 'N/A',
          error: '등번호 또는 완주 시간이 비어있습니다',
          hint: '모든 필수 컬럼을 입력해주세요'
        }
        next
      end

      # 참가자 찾기
      registration = @race.registrations.find_by(bib_number: bib_number)

      if registration.nil?
        error_records << {
          line: line_number,
          bib_number: bib_number,
          error: '해당 등번호의 참가자를 찾을 수 없습니다',
          hint: '등번호를 확인하거나 참가자 명단에서 등번호를 확인해주세요'
        }
        next
      end

      # 시간 파싱
      net_time = parse_time(net_time_str)

      if net_time.nil?
        error_records << {
          line: line_number,
          bib_number: bib_number,
          error: "시간 형식 오류: '#{net_time_str}'",
          hint: '올바른 형식: 1:23:45 (시:분:초) 또는 23:45 (분:초)'
        }
        next
      end

      # 기록 저장
      record = Record.find_or_initialize_by(
        user: registration.user,
        race_edition: registration.race_edition
      )

      is_update = record.persisted?

      record.net_time = net_time
      record.gun_time = net_time
      record.registration = registration

      if record.save
        if is_update
          updated_records << {
            line: line_number,
            bib_number: bib_number,
            name: registration.user.name,
            time: net_time
          }
        else
          success_records << {
            line: line_number,
            bib_number: bib_number,
            name: registration.user.name,
            time: net_time
          }
        end
      else
        error_records << {
          line: line_number,
          bib_number: bib_number,
          error: record.errors.full_messages.join(', '),
          hint: '관리자에게 문의하세요'
        }
      end
    end

    # 결과를 세션에 저장
    session[:upload_result] = {
      success: success_records,
      updated: updated_records,
      errors: error_records,
      race_id: @race.id
    }

    # 결과 요약 메시지
    total_success = success_records.count + updated_records.count
    messages = []

    if total_success > 0
      messages << "✅ #{success_records.count}건 신규 등록"
      messages << "🔄 #{updated_records.count}건 업데이트" if updated_records.any?
    end

    if error_records.any?
      messages << "❌ #{error_records.count}건 실패"
    end

    if total_success > 0
      flash[:success] = messages.join(', ')
    elsif error_records.any?
      flash[:error] = "업로드 실패: #{error_records.count}건의 오류가 발생했습니다"
    end

    redirect_to upload_result_organizer_race_records_path(@race)
  end

  def upload_result
    @result = session[:upload_result]

    unless @result && @result[:race_id] == @race.id
      flash[:error] = '업로드 결과를 찾을 수 없습니다.'
      redirect_to organizer_race_records_path(@race)
      return
    end

    @success_records = @result[:success] || []
    @updated_records = @result[:updated] || []
    @error_records = @result[:errors] || []
  end

  def download_sample
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['등번호', '완주 시간']
      csv << ['1', '1:23:45']
      csv << ['2', '1:25:30']
      csv << ['3', '1:28:15']
    end

    send_data csv_data,
              filename: "기록_업로드_샘플.csv",
              type: 'text/csv; charset=utf-8',
              disposition: 'attachment'
  end

  private

  def detect_and_convert_encoding(binary_data)
    # UTF-8 시도
    begin
      text = binary_data.force_encoding('UTF-8')
      return text if text.valid_encoding?
    rescue
      # UTF-8 실패 시 다음으로
    end

    # EUC-KR 시도 (한국어 윈도우 엑셀)
    begin
      text = binary_data.force_encoding('EUC-KR').encode('UTF-8')
      return text
    rescue
      # EUC-KR 실패 시 다음으로
    end

    # CP949 시도 (확장 완성형)
    begin
      text = binary_data.force_encoding('CP949').encode('UTF-8')
      return text
    rescue
      # CP949도 실패
    end

    # 모두 실패 시 UTF-8로 강제 변환 (깨질 수 있음)
    binary_data.force_encoding('UTF-8').encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
  end

  def parse_time(time_str)
    # "1:23:45" → "01:23:45" (시:분:초)
    # "23:45" → "00:23:45" (분:초)
    # "145" → "00:01:45" (초 only)

    return nil if time_str.blank?

    parts = time_str.split(':').map(&:to_i)

    case parts.length
    when 3
      # HH:MM:SS format
      format('%02d:%02d:%02d', parts[0], parts[1], parts[2])
    when 2
      # MM:SS format (assume hours = 0)
      format('00:%02d:%02d', parts[0], parts[1])
    when 1
      # SS format (assume hours = 0, minutes = 0)
      format('00:00:%02d', parts[0])
    else
      nil
    end
  rescue
    nil
  end

  def set_race
    @race = current_organizer_profile.races.find(params[:race_id])
  end

  def authorize_race_access!
    return if current_user.admin?
    return if @race.organizer.user_id == current_user.id

    redirect_to organizer_root_path, alert: '접근 권한이 없습니다.'
  end
end
