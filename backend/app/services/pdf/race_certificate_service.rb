module Pdf
  class RaceCertificateService
    def self.generate_html(registration)
      race = registration.race
      user = registration.user
      record = registration.records&.first

      <<~HTML
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>완주 증명서</title>
          <style>
            @page { size: A4 landscape; margin: 2cm; }
            body { font-family: 'Apple SD Gothic Neo', 'Noto Sans KR', sans-serif; text-align: center; padding: 40px; }
            .certificate { border: 3px double #4F46E5; padding: 60px; max-width: 800px; margin: 0 auto; }
            .title { font-size: 32px; font-weight: bold; color: #4F46E5; margin-bottom: 20px; }
            .subtitle { font-size: 14px; color: #666; margin-bottom: 40px; }
            .name { font-size: 28px; font-weight: bold; margin: 30px 0; }
            .detail { font-size: 16px; color: #333; margin: 10px 0; }
            .record { font-size: 24px; font-weight: bold; color: #4F46E5; margin: 20px 0; }
            .footer { margin-top: 40px; font-size: 12px; color: #999; }
            .seal { margin-top: 30px; font-size: 18px; color: #4F46E5; }
            @media print { body { padding: 0; } }
          </style>
        </head>
        <body>
          <div class="certificate">
            <div class="title">완주 증명서</div>
            <div class="subtitle">Certificate of Completion</div>
            <div class="name">#{user.display_name}</div>
            <div class="detail">위 사람은 아래 대회에 참가하여 완주하였음을 증명합니다.</div>
            <div class="detail" style="margin-top: 30px;">
              <strong>대회명:</strong> #{race.title}
            </div>
            <div class="detail"><strong>일시:</strong> #{race.start_at.strftime('%Y년 %m월 %d일')}</div>
            <div class="detail"><strong>종목:</strong> #{registration.race_edition.name}</div>
            #{record ? "<div class=\"record\">기록: #{record.net_time}</div>" : ""}
            <div class="detail"><strong>등번호:</strong> #{registration.bib_number || '-'}</div>
            <div class="seal">🏃 Runner's Connect</div>
            <div class="footer">발급일: #{Date.current.strftime('%Y년 %m월 %d일')}</div>
          </div>
        </body>
        </html>
      HTML
    end
  end
end
