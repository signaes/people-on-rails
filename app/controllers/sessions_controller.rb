class SessionsController < ApplicationController
  def new
  end

  def create
    @person = Person.find_by email: person_email

    if @person && @person.authenticate(person_password)
      check_activation
    else
      flash.now[:danger] = I18n.t('login.error_message')
      render 'new'
    end
  end

  def destroy
    log_out if person_is_logged_in?
    redirect_to root_url
  end

  private

  def check_activation
    if @person.activated?
      log_in @person
      remember_me? ? remember(@person) : forget(@person)
      redirect_back_or profile_url
    else
      message = I18n.t('login.pending_activation_message')
      flash[:warning] = message
      redirect_to root_url
    end
  end

  def person_email
    params[:session][:email].downcase
  end

  def person_password
    params[:session][:password]
  end

  def remember_me?
    params[:session][:remember_me] == '1'
  end
end
