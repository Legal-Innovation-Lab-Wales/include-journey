# frozen_string_literal: true

# app/helpers/qr_code_helper.rb
module QrCodeHelper
  def qr_code_as_svg(uri)
    RQRCode::QRCode.new(uri).as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 4,
      standalone: true,
    ).html_safe
  end
end
