class InfectedUserReport < ApplicationRecord
  belongs_to :suspect, class_name: "User"
  belongs_to :reporter, class_name: "User"
end
