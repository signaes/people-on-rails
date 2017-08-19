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

  test 'login with valid information' do
    get login_path
    post login_path, params: { session: { email: @person.email,
                                          password: 'password' } }
    assert_redirected_to profile_url
    follow_redirect!
    assert_template 'people/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', profile_path
  end

  test 'logout' do
    get login_path
    post login_path, params: { session: { email: @person.email,
                                          password: 'password' } }
    assert is_person_logged_in?
    assert_redirected_to profile_url
    follow_redirect!
    assert_template 'people/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', signup_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', profile_path

    # send a delete request to the logout_path
    delete logout_path
    assert_not is_person_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', signup_path
    assert_select 'a[href=?]', logout_path,  count: 0
    assert_select 'a[href=?]', profile_path, count: 0
  end
end
