# frozen_string_literal: true

# app/helpers/qr_code_helper.rb
module QrCodeHelper
  def qr_code_as_svg(uri)
    svg = RQRCode::QRCode.new(uri).as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 4,
      standalone: true,
    )

    # This is safe because the RQRCode library generates valid SVG code.
    # The URI does not come from user input anyway.
    svg.html_safe # rubocop:disable Rails/OutputSafety
  end
end
