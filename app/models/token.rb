class Token < ApplicationRecord
  belongs_to :users, class_name: 'User', optional: true
  belongs_to :applications, class_name: 'Application'
end
