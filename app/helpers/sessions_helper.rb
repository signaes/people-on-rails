module SessionsHelper
  def log_in(person)
    session[:person_id] = person.id
  end

  def log_out
    forget current_person
    session.delete :person_id
    @current_person = nil
  end

  # Forgets a persistent session.
  def forget(person)
    person.forget
    cookies.delete :person_id
    cookies.delete :remember_token
  end

  # Returns the user corresponding to the session or the remember token cookie.
  def current_person
    return nil if !(session[:person_id] || cookies.signed[:person_id])

    if (person_id = session[:person_id])
      @current_person ||= Person.find_by(id: person_id)
    elsif (person_id = cookies.signed[:person_id])
      person = Person.find_by(id: person_id)

      if person && person.authenticated?(cookies[:remember_token])
        log_in person
        @current_person = person
      end
    end
  end

  def person_is_logged_in?
    !current_person.nil?
  end

  # Remembers a person in a persistent session.
  def remember(person)
    person.remember
    cookies.permanent.signed[:person_id] = person.id
    cookies.permanent[:remember_token] = person.remember_token
  end

  # Redirect to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete :forwarding_url
  end

  # Stores the URL that the person tryied to access
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
