module Services
  module User
    class UpdateLocationService
      attr_reader :errors

      def initialize(user:, latitude:, longitude:)
        @user = user
        @latitude = latitude
        @longitude = longitude
        @errors = {}
      end

      def call
        valid? && user.update(latitude:, longitude:)
      end

      def error_messages
        result = @errors.map do |attr, message|
          "#{attr.capitalize}: #{message}"
        end
        result.join(", ")
      end

      private
        attr_reader :user, :latitude, :longitude

        def valid?
          errors[:user] ||= "Should not be blank" and return false if user.blank?
          errors[:latitude] ||= "Should not be blank" and return false if latitude.blank?
          errors[:longitude] ||= "Should not be blank" and return false if longitude.blank?
          errors[:latitude] ||= "Should be numeric" and return false unless latitude.is_a?(Numeric)
          errors[:longitude] ||= "Should be numeric" and return false unless longitude.is_a?(Numeric)
          true
        end
    end
  end
end
