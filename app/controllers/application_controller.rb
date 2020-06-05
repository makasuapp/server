# typed: ignore
class ApplicationController < ActionController::Base
  def status
    render json: {message: "ok"}
  end
end
