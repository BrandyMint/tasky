# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  layout 'simple'

  before_action :require_user, except: %i[new create]

  def new
    render locals: { form: PasswordReset.new }
  end

  # request password reset.
  # you get here when the user entered his email in the reset password form and submitted it.
  def create
    unless form.valid?
      render :new, locals: { form: form }
      return
    end

    deliver_instruction form.email

    render
  end

  # This is the reset password form.
  def edit
    render locals: { token: token, user: user }
  end

  # This action fires when the user has sent the reset password form.
  def update
    form = params.require(:user).permit(:password, :password_confirmation)
    # the next line makes the password confirmation validation work
    user.password_confirmation = form[:password_confirmation]
    # the next line clears the temporary token and updates the password
    if user.change_password form[:password]
      redirect_to root_path, notice: 'Пароль восстановлен'
    else
      render :edit, locals: { user: user, token: token }
    end
  end

  private

  def deliver_instruction(email)
    user = User.find_by email: email

    if user.present?
      user.deliver_reset_password_instructions!
    else
      Rails.logger.error "No user found (#{email}) to restore"
    end
  end

  def require_user
    return if user.present?

    render :new,
           notice: 'Ссылка на восстановление пароля устарела. Сделайте восстановление еще раз.'
  end

  def token
    params[:id]
  end

  def user
    return @user if instance_variable_defined? :@user

    @user = UserWithPassword.load_from_reset_password_token token
  end

  def form
    @form ||= PasswordReset.new params[:password_reset].permit(:email)
  end
end
