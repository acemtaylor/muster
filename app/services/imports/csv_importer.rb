require "csv"

module Imports
  class CsvImporter
    Result = Struct.new(:created_count, :error_count, :errors, keyword_init: true)

    COLUMN_MAP = {
      "first_name"      => :first_name,
      "last_name"       => :last_name,
      "email"           => :email,
      "phone_number"    => :phone_number,
      "secondary_phone" => :secondary_phone,
      "address_1"       => :address_1,
      "address_2"       => :address_2,
      "city"            => :city,
      "state"           => :state,
      "postal_code"     => :postal_code,
      "country"         => :country
    }.freeze

    def initialize(organization:, file_path:)
      @organization = organization
      @file_path = file_path
    end

    def call
      created = 0
      errors = []

      CSV.foreach(@file_path, headers: true) do |row|
        attrs = { organization: @organization, created_by_method: "import" }

        COLUMN_MAP.each do |csv_header, attr_name|
          value = row[csv_header]
          attrs[attr_name] = value.strip if value.present?
        end

        person = Person.new(attrs)

        if person.save
          created += 1
        else
          errors << { row: row.to_h, messages: person.errors.full_messages }
        end
      end

      Result.new(created_count: created, error_count: errors.size, errors: errors)
    end
  end
end
