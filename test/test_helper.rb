require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def is_person_logged_in?
    !session[:person_id].nil?
  end

  def clear_database(model)
    model.all.each { |record| record.delete }
  end

  def clear_people
    clear_database Person
  end
end
