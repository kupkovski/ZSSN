module Services
  module User
    class CreateService
      def initialize(name:, gender:, latitude:, longitude:, birthdate:)
        @name = name
        @gender = gender
        @latitude = latitude
        @longitude = longitude
        @birthdate = birthdate
      end

      def call
        user = ::User.new(
          name: name,
          gender: gender,
          latitude: latitude,
          longitude: longitude,
          birthdate: birthdate,
        )

        if user.save!
          after_create!(user)
        end
      end

      private
      attr_reader :name, :gender, :latitude, :longitude, :birthdate

      def after_create!(user)
        user.create_inventory!
      end
    end
  end
end
