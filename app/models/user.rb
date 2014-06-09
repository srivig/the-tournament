class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :tournaments, dependent: :restrict_with_exception
  validates :accept_terms, acceptance: true, on: :create

  def creatable?
    self.tournaments.count < 3 || self.admin?
  end
end
