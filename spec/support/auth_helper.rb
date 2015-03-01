module AuthHelper
  def http_login(user = nil, passowrd = nil)
    user ||= Rails.application.secrets.admin_user
    password ||= Rails.application.secrets.admin_password

    request.env["HTTP_AUTHORIZATION"] = ActionController::HttpAuthentication::Basic.encode_credentials(user,password)
  end
end