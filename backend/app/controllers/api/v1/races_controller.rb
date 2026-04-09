module Api
  module V1
    class RacesController < Api::BaseController
      # GET /api/v1/races
      def index
        @races = Race.where(status: 'open').includes(:race_editions, :organizer).order(start_at: :asc)
        render json: RaceSerializer.new(@races, include: [:race_editions]).serializable_hash
      end

      # GET /api/v1/races/:id
      def show
        @race = Race.includes(:race_editions, :organizer).find(params[:id])
        render json: RaceSerializer.new(@race, include: [:race_editions]).serializable_hash
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Race not found' }, status: :not_found
      end

      # GET /api/v1/races/:id/results?bib=123 or ?name=홍길동
      def results
        @race = Race.find(params[:id])
        edition = @race.race_editions.order(created_at: :desc).first

        return render json: { error: '기록이 아직 등록되지 않았습니다.' }, status: :not_found unless edition

        # 배번호 또는 이름으로 검색
        if params[:bib].present?
          registration = edition.registrations.find_by(bib_number: params[:bib].to_s.strip)
          return render json: { error: '해당 배번호를 찾을 수 없습니다.' }, status: :not_found unless registration

          record = edition.records.find_by(registration_id: registration.id) ||
                   edition.records.find_by(user_id: registration.user_id)

          render json: build_record_json(record, registration, @race, edition)

        elsif params[:name].present?
          users = User.where("name LIKE ?", "%#{params[:name].strip}%")
          registrations = edition.registrations.where(user_id: users.ids, status: 'paid')

          results = registrations.map do |reg|
            record = edition.records.find_by(registration_id: reg.id) ||
                     edition.records.find_by(user_id: reg.user_id)
            build_record_json(record, reg, @race, edition)
          end

          render json: { results: results }

        else
          # 전체 기록 목록 (최대 100개)
          records = edition.records.includes(:registration, :user)
                          .order(net_time: :asc).limit(100)
          results = records.map do |record|
            build_record_json(record, record.registration, @race, edition)
          end
          render json: { results: results, total: edition.records.count }
        end

      rescue ActiveRecord::RecordNotFound
        render json: { error: '대회를 찾을 수 없습니다.' }, status: :not_found
      end

      private

      def build_record_json(record, registration, race, edition)
        user = registration&.user

        # net_time을 초 단위로 파싱해서 표시용 문자열 생성
        net_time_display = format_time(record&.net_time)
        gun_time_display = format_time(record&.gun_time)

        {
          bib_number: registration&.bib_number,
          name: user&.name || '미확인',
          race_title: race.title,
          race_date: edition.start_at&.strftime('%Y년 %m월 %d일'),
          location: race.location,
          net_time: record&.net_time,
          net_time_display: net_time_display,
          gun_time: record&.gun_time,
          gun_time_display: gun_time_display,
          rank_overall: record&.rank_overall,
          rank_gender: record&.rank_gender,
          rank_age: record&.rank_age,
          splits: record&.splits,
          is_verified: record&.is_verified,
          certificate_url: record&.certificate_url,
          has_record: record.present?
        }
      end

      def format_time(time_str)
        return nil unless time_str.present?
        # "HH:MM:SS" 형식이면 그대로, 초 단위 숫자면 변환
        if time_str.match?(/^\d+$/)
          total_seconds = time_str.to_i
          hours = total_seconds / 3600
          minutes = (total_seconds % 3600) / 60
          seconds = total_seconds % 60
          hours > 0 ? format('%d:%02d:%02d', hours, minutes, seconds) : format('%d:%02d', minutes, seconds)
        else
          time_str
        end
      end
    end
  end
end
