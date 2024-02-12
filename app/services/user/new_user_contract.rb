require 'dry-validation'

module Services
  module User
    class NewUserContract < Dry::Validation::Contract
      params do
        required(:name).filled(:string)
        required(:gender).filled(:string)
        required(:latitude).filled(:float)
        required(:longitude).filled(:float)
        required(:birthdate).filled(:date)
      end
    end
  end
end
