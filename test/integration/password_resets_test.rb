require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @person = people :testable
  end

  def with_invalid_email
    post password_resets_path, params: { password_reset: { email: '' } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
  end

  def with_valid_email
    post password_resets_path,
         params: { password_reset: { email: @person.email } }
    assert_not_equal @person.reset_digest, @person.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  def with_wrong_email(person)
    get edit_password_reset_path(person.reset_token, email: '')
    assert_redirected_to root_url
  end

  def with_inactive_person(person)
    person.toggle :activated
    person.save validate: false
    get edit_password_reset_path(person.reset_token, email: person.email)
    assert_redirected_to root_url
    person.toggle :activated
    person.save validate: false
  end

  def with_right_email_and_wrong_token(person)
    get edit_password_reset_path('wrong token', email: person.email)
    assert_redirected_to root_url
  end

  def with_right_email_and_token(person)
    get edit_password_reset_path(person.reset_token, email: person.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', person.email
  end

  def with_invalid_password_and_confirmation(person)
    patch password_reset_path(person.reset_token),
          params: { email: person.email,
                    person: { password: '123456',
                              password_confirmation: '789101' } }
    assert_select 'body' do |content|
      assert_match(/confirmation doesn't match/, content.to_s)
    end
  end

  def with_empty_password(person)
    patch password_reset_path(person.reset_token),
          params: { email: person.email,
                    person: { password: '',
                              password_confirmation: '' } }
    assert_select 'body' do |content|
      assert_match(I18n.t('errors.empty_password'), content.to_s)
    end
  end

  def with_valid_password_and_confirmation(person)
    patch password_reset_path(person.reset_token),
          params: { email: person.email,
                    person: { password: 'new_password',
                              password_confirmation: 'new_password' } }
    assert person_logged_in?
    assert_not flash.empty?
    assert_redirected_to profile_path
    assert_nil person.reload.reset_digest
  end

  test 'password resets' do
    get new_password_reset_path
    assert_template 'password_resets/new'

    with_invalid_email
    with_valid_email

    # Password reset form
    person = assigns :person

    with_wrong_email(person)
    with_inactive_person(person)
    with_right_email_and_wrong_token(person)
    with_right_email_and_token(person)
    with_invalid_password_and_confirmation(person)
    with_empty_password(person)
    with_valid_password_and_confirmation(person)
  end

  test 'expired token' do
    get new_password_reset_path
    post password_resets_path,
         params: { password_reset: { email: @person.email } }

    @person = assigns :person
    @person.reset_sent_at = 3.hours.ago
    @person.save validate: false
    patch password_reset_path(@person.reset_token),
          params: { email: @person.email,
                    person: { password: 'new_password',
                              password_confirmation: 'new_password' } }
    assert_response :redirect
    follow_redirect!
    assert_match I18n.t('password_reset.expired_token'), response.body
  end
end
