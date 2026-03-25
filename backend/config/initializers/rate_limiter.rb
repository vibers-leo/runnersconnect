# 간단한 레이트 리미터 (rack-attack 대신 Rails 캐시 기반)
# gem 추가 없이 동작 — Hotwire + API 듀얼 모드 대응

class RateLimiter
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    ip = request.ip
    path = request.path

    # API 엔드포인트: 60회/분
    if path.start_with?('/api/')
      return too_many_requests_json if rate_exceeded?("api:#{ip}", 60, 1.minute)
    end

    # 인증 엔드포인트: 5회/20초
    if auth_path?(path) && request.post?
      return too_many_requests(request) if rate_exceeded?("auth:#{ip}", 5, 20.seconds)
    end

    # 등록 엔드포인트: 10회/분
    if path.match?(/\/registrations/) && request.post?
      return too_many_requests(request) if rate_exceeded?("reg:#{ip}", 10, 1.minute)
    end

    # 일반 웹: 300회/5분
    return too_many_requests(request) if rate_exceeded?("web:#{ip}", 300, 5.minutes)

    @app.call(env)
  end

  private

  def auth_path?(path)
    path.match?(/\/(sign_in|login|sign_up|auth)/)
  end

  def rate_exceeded?(key, limit, period)
    count = Rails.cache.increment(key, 1, expires_in: period) || 1
    count > limit
  end

  def too_many_requests(request)
    if request.path.start_with?('/api/')
      too_many_requests_json
    else
      too_many_requests_html
    end
  end

  def too_many_requests_json
    [429, { 'Content-Type' => 'application/json; charset=utf-8' },
     [{ error: '요청이 너무 많습니다.' }.to_json]]
  end

  def too_many_requests_html
    [429, { 'Content-Type' => 'text/html; charset=utf-8' },
     ['<html><body><h1>요청이 너무 많습니다</h1><p>잠시 후 다시 시도해 주세요.</p></body></html>']]
  end
end

# 미들웨어 등록
Rails.application.config.middleware.insert_before 0, RateLimiter
