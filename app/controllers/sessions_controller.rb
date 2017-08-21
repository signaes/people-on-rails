class SessionsController < ApplicationController
  def new
  end

  def create
    @person = Person.find_by email: person_email

    if @person && @person.authenticate(person_password)
      log_in @person
      remember_me? ? remember(@person) : forget(@person)
      redirect_to profile_url
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
