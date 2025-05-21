require 'active_model_serializers'

class UserSerializer < ActiveModel::Serializer

  attributes :id, :name, :age, :birthdate, :gender, 
             :latitude, :longitude, :infected

  def age
    ((Date.today - object.birthdate.to_date) / 365).floor
  end

  def infected
    object.infected?
  end
end
