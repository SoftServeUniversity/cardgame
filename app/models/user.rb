class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]
  has_one :player

  after_initialize do
    self.games_count ||= 0
    self.lose_count ||= 0
    self.win_count ||= 0
    self.view_theme ||= "Classic"
  end

  validates :username, :uniqueness => { :case_sensitive => false}

  def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end
end
