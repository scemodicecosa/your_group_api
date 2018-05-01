# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
u = FactoryBot.create(:user)
u2 = FactoryBot.create(:user)
u3 = FactoryBot.create(:user)

g = FactoryBot.create(:group)
g.add_user(u.id, true)
g.add_user(u2.id)