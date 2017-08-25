require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @person = people :testable
    remember @person
  end

  test 'current_person returns right person when session is nil' do
    assert_equal @person, current_person
    assert person_logged_in?
  end

  test 'current_person returns nil when remember digest is wrong' do
    @person.remember_digest = Person.digest(Person.new_token)
    @person.save validate: false
    assert_nil current_person
  end
end
