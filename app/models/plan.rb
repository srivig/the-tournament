class Plan < ActiveRecord::Base
  belongs_to :user
  DEFAULT_SIZE = 32
end
