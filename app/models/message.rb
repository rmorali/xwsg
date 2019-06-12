class Message < ActiveRecord::Base
  belongs_to :sender, class_name: 'Squad'
  belongs_to :receiver, class_name: 'Squad'
end
