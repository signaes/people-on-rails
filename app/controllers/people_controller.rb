class PeopleController < ApplicationController
  before_action :check_if_person_is_logged_in, only: [:show, :edit, :update, :destroy]
  before_action :find_person, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new person_params

    if @person.save
      log_in @person
      flash[:success] = I18n.t('signup.success_message')
      redirect_to profile_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @person.update_attributes(person_params)
      flash[:success] = I18n.t('person.edit.success_message')
      redirect_to profile_url
    else
      render 'edit'
    end
  end

  def destroy
    @person.destroy
    flash[:success] = I18n.t('person.delete_account.success_message')
    redirect_to :root
  end

  private

  def person_params
    params.require(:person).permit(:name, :email, :password,
                                   :password_confirmation)
  end

  def find_person
    @person = current_person
  end

  # Before filters

  def check_if_person_is_logged_in
    unless person_is_logged_in?
      store_location
      flash[:danger] = I18n.t('person.unauthorized_error_message')
      redirect_to login_url
    end
  end
end
