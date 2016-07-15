class Plan < ActiveRecord::Base
  belongs_to :user
  DEFAULT_COUNT = 10
  DEFAULT_SIZE = 32
end
