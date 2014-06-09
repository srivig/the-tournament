class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :tournaments, dependent: :restrict_with_exception

  def creatable?
    !(self.tournaments.count >= 3)
  end
end
