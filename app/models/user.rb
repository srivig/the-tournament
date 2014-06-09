class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :tournaments, dependent: :restrict_with_exception
  validates_acceptance_of :terms, on: :create, allow_nil: false, message: 'Agree to the terms of use and privacy policy before registration.'

  def creatable?
    self.tournaments.count < 3 || self.admin?
  end
end
