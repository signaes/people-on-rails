require 'test_helper'

class PeopleVisitProfileTest < ActionDispatch::IntegrationTest
  setup do
    @person = people :testable
  end

  test 'login with valid information and is redirected to the profile page' do
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
  end

  test 'should be redirected to the homepage if visiting the profile path without being logged in' do
    get profile_path

    assert_redirected_to root_url
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', signup_path
    assert_select 'a[href=?]', logout_path,  count: 0
    assert_select 'a[href=?]', profile_path, count: 0
  end
end

