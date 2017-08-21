require 'test_helper'

class PeopleControllerTest < ActionDispatch::IntegrationTest
  def setup
    @person = people :testable
  end

  test 'should get new' do
    get signup_path
    assert_response :success
  end

  test 'should redirect profile when not logged in' do
    get profile_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit when not logged in' do
    get profile_edit_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch profile_edit_path, params: { person: { name: @person.name,
                                                 email: @person.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should friendly forward edit' do
    get profile_edit_path
    assert_not flash.empty?
    assert_redirected_to login_url
    log_in_as @person
    assert_redirected_to profile_edit_path
    assert_nil session[:forwarding_url]
    log_out
    get login_url
    assert_nil session[:forwarding_url]
    log_in_as @person
    assert_redirected_to profile_path
    assert_nil session[:forwarding_ur]
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Person.count' do
      delete delete_account_path
    end
    assert_redirected_to login_url
  end

  test 'should be able to delete account if logged in' do
    log_in_as @person
    get profile_edit_path
    assert_select 'a[href=?]', delete_account_path
    assert_difference 'Person.count', -1 do
      delete delete_account_path
    end
  end
end
