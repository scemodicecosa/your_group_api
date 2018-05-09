module Authenticable

  def current_user
    @current_user ||= User.find_by_auth_token(request.headers["Authorization"])
  end

  def authenticate_with_token!
    render(json: {errors: "You are not authorized!"},status: :unauthorized) unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end

  def is_in?(user_id, group_id)
    Role.where(group_id: group_id, user_id: user_id, accepted: true).present?
  end

  def is_admin_in?(user_id, group_id)
    Role.where(group_id: group_id, user_id: user_id, accepted: true, admin: true).present?
  end
end