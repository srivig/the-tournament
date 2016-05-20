class Plan < ActiveRecord::Base
  belongs_to :user
  DEFAULT_COUNT = 2
  DEFAULT_SIZE = 32
end
