require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Returns true if a test person is logged in
  def is_person_logged_in?
    !session[:person_id].nil?
  end

  # Log in a test person
  def log_in_as(person)
    session[:person_id] = person.id
  end

  def log_out
    session.delete :person_id
  end

  def clear_database(model)
    model.all.each { |record| record.delete }
  end

  def clear_people
    clear_database Person
  end
end

class ActionDispatch::IntegrationTest
  # Log in a test person
  def log_in_as(person, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: person.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
