class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :player

  after_initialize :init

  def init
      self.games_count ||= 0
      self.lose_count ||= 0
      self.win_count ||= 0
    end
end
