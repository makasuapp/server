# typed: ignore
class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :set_raven_context

  def authenticate_api_user!
    authenticate_or_request_with_http_token do |token|
      begin
        jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first

        @current_user_id = jwt_payload['id']
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        head :unauthorized
      end
    end
  end

  def current_user
    if @current_user_id.nil?
      @current_user ||= super
    else
      @current_user = User.find(@current_user_id)
    end
  end

  def signed_in?
    @current_user_id.present?
  end

  def status
    render json: {message: "ok"}
  end

  private

  def set_raven_context
    Raven.user_context(id: @current_user_id) 
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
