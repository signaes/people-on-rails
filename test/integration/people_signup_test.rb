require 'test_helper'

class PeopleSignupTest < ActionDispatch::IntegrationTest
  def setup
    clear_people
  end

  test 'should not sign up without email' do
    get signup_path

    assert_no_difference 'Person.count' do
      post signup_path, params: { person: { name: '',
                                            email: '',
                                            password: 'ooo',
                                            password_confirmation: 'aaa' } }
    end

    assert_template 'people/new'
    assert_select 'body' do |content|
      assert_match /Email can't be blank/, content.to_s
    end
  end

  test 'should sign up with all the required fields' do
    get signup_path

    assert_difference 'Person.count', 1 do
      post signup_path, params: { person: { name: 'Testable',
                                            email: 'testable@mail.com',
                                            password: '123456',
                                            password_confirmation: '123456' } }
    end

    follow_redirect!
    assert_template 'people/show'
    assert_not flash.empty?
    assert is_person_logged_in?
  end
end
