class PeopleController < ApplicationController
  def show
    return redirect_to(:root) if !(current_person || params[:id])

    @person = current_person || Person.find(params[:id])
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

  private

  def person_params
    params.require(:person).permit(:name, :email, :password,
                                   :password_confirmation)
  end
end
