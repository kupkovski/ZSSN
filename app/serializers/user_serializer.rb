require "active_model_serializers"

class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :age, :gender,
             :latitude, :longitude, :infected

  def age
    ((Date.today - object.birthdate.to_date) / 365).floor
  end

  def infected
    # TODO: implement object.infected?
    false
  end
end
