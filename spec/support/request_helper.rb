module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module HeaderHelpers
    def api_auth_token(token)
      request.headers["Authorization"] = token
    end
  end

  module UserHelpers
    def accept_invite(user_id, group_id)
      r = Role.where(user_id: user_id, group_id: group_id).first
      r.update!(accepted: true)
    end
  end
end