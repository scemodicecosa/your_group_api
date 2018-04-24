class Group < ApplicationRecord

  validates :name, presence:true
  has_many :roles
  has_many :users, through: :roles



  def add_user(u)
    Role.create!(name: 'Participant', user: u, group: self)
  end

  def add_admin(u)
    Role.create(name: 'Admin', user: u, group: self, admin: true)
  end

end
