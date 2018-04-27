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
end