module ApplicationHelper
  def render_qr_code(token)
    qrcode = RQRCode::QRCode.new(token)
    qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true,
      use_path: true
    ).html_safe
  end

  def format_duration(seconds)
    return "--:--" if seconds.nil?
    Time.at(seconds).utc.strftime("%H:%M:%S")
  end
end
