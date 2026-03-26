module Pdf
  class SettlementReceiptService
    def self.generate_html(settlement)
      race = settlement.race
      organizer = settlement.organizer_profile

      <<~HTML
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>정산 영수증</title>
          <style>
            body { font-family: 'Apple SD Gothic Neo', 'Noto Sans KR', sans-serif; padding: 40px; max-width: 600px; margin: 0 auto; }
            .header { text-align: center; margin-bottom: 30px; }
            .title { font-size: 24px; font-weight: bold; }
            table { width: 100%; border-collapse: collapse; margin: 20px 0; }
            th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
            th { background: #f5f5f5; font-weight: bold; }
            .total { font-weight: bold; font-size: 18px; color: #4F46E5; }
            .footer { margin-top: 30px; text-align: center; font-size: 12px; color: #999; }
            @media print { body { padding: 20px; } }
          </style>
        </head>
        <body>
          <div class="header">
            <div class="title">정산 영수증</div>
            <p>Runner's Connect</p>
          </div>
          <table>
            <tr><th>대회명</th><td>#{race.title}</td></tr>
            <tr><th>주최자</th><td>#{organizer.business_name}</td></tr>
            <tr><th>대회일</th><td>#{race.start_at.strftime('%Y-%m-%d')}</td></tr>
            <tr><th>참가자 수</th><td>#{settlement.registration_count}명</td></tr>
          </table>
          <table>
            <tr><th>항목</th><th style="text-align:right">금액</th></tr>
            <tr><td>총 매출</td><td style="text-align:right">#{number_with_comma(settlement.total_revenue)}원</td></tr>
            <tr><td>플랫폼 수수료 (5% + 500원/명)</td><td style="text-align:right">-#{number_with_comma(settlement.platform_commission)}원</td></tr>
            <tr><td class="total">지급 금액</td><td style="text-align:right" class="total">#{number_with_comma(settlement.organizer_payout)}원</td></tr>
          </table>
          <table>
            <tr><th>정산 상태</th><td>#{settlement.status_label}</td></tr>
            <tr><th>요청일</th><td>#{settlement.requested_at&.strftime('%Y-%m-%d') || '-'}</td></tr>
            <tr><th>승인일</th><td>#{settlement.approved_at&.strftime('%Y-%m-%d') || '-'}</td></tr>
            <tr><th>지급일</th><td>#{settlement.paid_at&.strftime('%Y-%m-%d') || '-'}</td></tr>
          </table>
          <div class="footer">
            <p>발급일: #{Date.current.strftime('%Y년 %m월 %d일')}</p>
            <p>Runner's Connect | runnersconnect.vibers.co.kr</p>
          </div>
        </body>
        </html>
      HTML
    end

    def self.number_with_comma(number)
      number.to_i.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    end
  end
end
