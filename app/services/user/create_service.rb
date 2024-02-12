require_relative 'new_user_contract'
module Services
  module User
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
          name: name,
          gender: gender,
          latitude: latitude,
          longitude: longitude,
          birthdate: birthdate,
        )

        after_create(user) if user && user.save
        user
      end

      private
      attr_reader :name, :gender, :latitude, :longitude, :birthdate

      def after_create(user)
        user.create_inventory
      end

      def valid?
        contract = NewUserContract.new.call(name:, gender:, latitude:, longitude:, birthdate:)
        @errors = contract.errors.to_h if contract.failure?

        contract.success?
      end
    end
  end
end
