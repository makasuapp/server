# typed: ignore
class ApplicationController < ActionController::Base
  #TODO(auth)
  protect_from_forgery with: :null_session

  def status
    render json: {message: "ok"}
  end
end
