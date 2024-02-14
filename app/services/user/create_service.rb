# frozen_string_literal: true

module Services
  module User
    # Orchestrate all required steps to create an User
    class CreateService
      attr_reader :errors

      def initialize(name:, gender:, latitude:, longitude:, birthdate:)
        @name = name
        @gender = gender
        @latitude = latitude
        @longitude = longitude
        @birthdate = birthdate

        @errors = {}
      end

      def call
        valid? &&
          user = ::User.new(
            name:,
            gender:,
            latitude:,
            longitude:,
            birthdate:
          )

        after_create(user) if user&.save
        user
      end

      private

      attr_reader :name, :gender, :latitude, :longitude, :birthdate

      def after_create(user)
        user.create_inventory
      end

      def valid?
        errors[:name] ||= 'Should not be blank' and return false if name.blank?
        errors[:gender] ||= 'Should not be blank' and return false if gender.blank?
        errors[:latitude] ||= 'Should not be blank' and return false if latitude.blank?
        errors[:longitude] ||= 'Should not be blank' and return false if longitude.blank?
        errors[:birthdate] ||= 'Should not be blank' and return false if birthdate.blank?

        true
      end
    end
  end
end
