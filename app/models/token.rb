class Token < ApplicationRecord
  belongs_to :user, class_name: 'User', optional: true
  belongs_to :application, class_name: 'Application'
end
