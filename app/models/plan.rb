class Plan < ActiveRecord::Base
  belongs_to :user
  DEFAULT_COUNT = 1
  DEFAULT_SIZE = 32
end
