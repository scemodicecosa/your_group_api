class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  #validates :email, presence: true ,unless: :phone_number
  validates :phone_number, presence: true ,unless: :email #TODO validates correct format of number
  validates :phone_number, uniqueness: true, allow_blank: true

  validates :auth_token, uniqueness: true, allow_nil: true

  before_create :generate_auth_token


  #has_and_belongs_to_many :groups
  has_many :roles, dependent: :destroy
  has_many :groups, through: :roles

  has_many :votes
  has_many :polls, through: :votes

  has_many :actions

  def email_required?
    self.phone_number.blank?
  end

  def generate_auth_token
    begin
      self.auth_token = Devise.friendly_token(35)
      #print self.auth_token
    end while User.exists?(auth_token: self.auth_token)
  end

end
