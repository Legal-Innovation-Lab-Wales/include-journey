# frozen_string_literal: true

# app/controllers/concerns/exportable.rb
module Exportable
  extend ActiveSupport::Concern
  require 'csv'
  require 'json'
  included do
    before_action :exportable, only: :export
  end

  protected

  def exportable
    @query = exportable_params[:query]
    @resources = @query.present? ? search : resources

    respond_to do |format|
      format.json { send_data @resources.map(&:json).to_json, filename: filename('json') }
      format.csv { send_data to_csv, filename: filename('csv') }
    end
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_headers

      @resources.each do |resource|
        csv << resource.to_csv
      end
    end
  end

  def csv_headers
    raise 'CSV Headers not overridden'
  end

  def base_path
    raise 'Base path not overridden'
  end

  def filename(type)
    "#{base_path}-#{Time.current.strftime('%Y-%m-%d-%H-%M-%S')}.#{type}"
  end

  def exportable_params
    params.permit(:query)
  end
end
