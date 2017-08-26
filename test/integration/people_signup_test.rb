require 'test_helper'

class PeopleSignupTest < ActionDispatch::IntegrationTest
  def setup
    clear_people
    ActionMailer::Base.deliveries.clear
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
      assert_match(I18n.t('errors.messages.blank'), content.to_s)
    end
  end

  test 'valid signup with account activation' do
    get signup_path

    assert_difference 'Person.count', 1 do
      params = { person: { name: 'Testable',
                           email: 'testable@mail.com',
                           password: 'password',
                           password_confirmation: 'password' } }
      post signup_path, params: params
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    person = assigns :person
    # Try to log in before activation
    log_in_as person
    assert_not person_logged_in?
    # Invalid activation token
    get edit_account_activation_path('invalid token',
                                     email: person.email)
    assert_not person_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(person.activation_token,
                                     email: 'wrong_email')
    assert_not person_logged_in?
    # Valid token and email
    get edit_account_activation_path(person.activation_token,
                                     email: person.email)
    assert person.reload.activated?

    follow_redirect!
    assert_template 'people/show'
    assert_not flash.empty?
    assert person_logged_in?
  end
end
