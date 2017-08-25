require 'test_helper'

class PeopleLoginTest < ActionDispatch::IntegrationTest
  setup do
    @person = people :testable
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', password: '' } }

    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'login with valid information followed by logout' do
    get login_path
    post login_path, params: { session: { email: @person.email,
                                          password: 'password' } }
    assert person_logged_in?
    assert_redirected_to profile_url
    follow_redirect!
    assert_template 'people/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', signup_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', profile_path
    assert_select 'a[href=?]', profile_edit_path

    # send a delete request to the logout_path
    delete logout_path
    assert_not person_logged_in?
    assert_redirected_to root_url

    # simulate a user clicking logout in a second browser window.
    delete logout_path

    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', signup_path
    assert_select 'a[href=?]', logout_path,  count: 0
    assert_select 'a[href=?]', profile_path, count: 0
    assert_select 'a[href=?]', profile_edit_path, count: 0
  end

  test 'log in with remember me checked' do
    log_in_as @person, remember_me: '1'
    assert_not_empty cookies['remember_token']
    assert_equal cookies['remember_token'], assigns(:person).remember_token
  end

  test 'log in with remember me unchecked' do
    # Log in to set the cookie.
    log_in_as @person, remember_me: '1'
    # Log in again and verify that the cookie is deleted.
    log_in_as @person, remember_me: '0'
    assert_empty cookies['remember_token']
  end
end
