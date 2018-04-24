class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  #validates :email, presence: true ,unless: :phone_number
  validates :phone_number, presence: true ,unless: :email #TODO validates correct format of number
  validates :phone_number, uniqueness: true

  #has_and_belongs_to_many :groups
  has_many :roles
  has_many :groups, through: :roles

  def email_required?
    self.phone_number.blank?

  end

end
