class AccountActivationsController < ApplicationController
  def edit
    person = Person.find_by(email: email)
    if person && !person.activated? && person.authenticated?(:activation, token)
      person.activate_account
      log_in person
      flash[:success] = I18n.t('signup.activation_success')
      redirect_to profile_url
    else
      flash[:danger] = I18n.t('signup.activation_invalid')
      redirect_to root_url
    end
  end

  private

  def email
    params[:email]
  end

  def token
    params[:id]
  end
end
