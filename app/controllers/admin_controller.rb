class AdminController < ApplicationController
  before_filter :authenticate


  protected

  def authenticate
    return true if session[:admin]
    authenticate_or_request_with_http_basic do |username, password|
      secrets = Rails.application.secrets

      if secrets.admin_user.eql?(username) && secrets.admin_password.eql?(password)
        session[:admin] = true
      else
        session[:admin] = false
        request_http_token_authentication
      end

    end
  end

end
