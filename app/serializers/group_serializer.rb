class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :users_ids
  def users_ids
    object.users.pluck(:id)
  end
end
