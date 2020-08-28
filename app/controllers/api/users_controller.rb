# typed: false
class Api::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]
  before_action :authenticate_api_user!, only: [:verify]

  def create
    @user = User.new(user_params)
    if @user.valid? && @user.save
      render :show
    else
      render json: @user.errors.full_messages, status: 400
    end
  end

  def show
    @user = current_user
  end

  def login
    auth = params[:auth]
    @user = User.find_by(email: auth[:email].downcase.strip)

    if @user && @user.valid_password?(auth[:password])
      render :show
    else
      render json: ['Email or password is invalid'], status: :unprocessable_entity
    end
  end

  def request_reset
    email = params[:email].downcase.strip
    user = User.find_by_email(email)

    if user.nil?
      render json: ['Email is invalid'], status: :unprocessable_entity
    else
      raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
      user.update_attributes!(reset_password_token: hashed, reset_password_sent_at: Time.now.utc)

      UserMailer.account_reset(email, raw).deliver_now

      head :ok
    end
  end

  def reset_password
    auth = params[:auth]
    user = User.reset_password_by_token({
      reset_password_token: params[:token],
      password: auth[:password],
      password_confirmation: auth[:password_confirmation]
    })

    if user.errors.messages.present?
      render json: ["An error occurred: #{user.errors.full_messages.join(", ")}"], status: :unprocessable_entity
    else
      head :ok
    end
  end

  def verify
    if current_user.id == params[:user]
      @user = current_user
      render :show
    else
      render json: ['User does not match'], status: 400
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :phone_number, :first_name, :last_name, :password, :password_confirmation)
  end
end
