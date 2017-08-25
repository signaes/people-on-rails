class PasswordResetsController < ApplicationController
  before_action :find_person, only: [:edit, :update]
  before_action :check_authenticity, only: [:edit, :update]
  before_action :check_token_expiration, only: [:edit, :update]

  def new
  end

  def edit
  end

  def create
    @person = Person.find_by(
      email: params[:password_reset][:email].try(:downcase)
    )

    if @person
      setup_reset
    else
      reset_email_not_found
    end
  end

  def update
    if password.empty?
      @person.errors.add :password, I18n.t('errors.empty_password')
      render 'edit'
    elsif @person.update_attributes(person_params)
      successfully_update
    else
      render 'edit'
    end
  end

  private

  def setup_reset
    @person.create_reset_digest
    @person.send_password_reset_email
    flash[:info] = I18n.t('password_reset.email_sent')
    redirect_to :root
  end

  def reset_email_not_found
    flash.now[:danger] = I18n.t('password_reset.email_not_found')
    render 'new'
  end

  def successfully_update
    log_in @person
    @person.reset_digest = nil
    @person.save validate: false
    flash[:success] = I18n.t('password_reset.success_message')
    redirect_to profile_path
  end

  def find_person
    @person = Person.find_by email: email
  end

  def email
    params[:email].try :downcase
  end

  def password
    params[:person][:password]
  end

  def person_params
    params.require(:person).permit(:password, :password_confirmation)
  end

  def check_authenticity
    unless @person && @person.activated? &&
           @person.authenticated?(:reset, reset_token)
      redirect_to :root
    end
  end

  def reset_token
    params[:id]
  end

  # Checks expiration of reset token
  def check_token_expiration
    return unless @person.password_reset_expired?

    flash[:danger] = I18n.t('password_reset.expired_token')
    redirect_to new_password_reset_url
  end
end
