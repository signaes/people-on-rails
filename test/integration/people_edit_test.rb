require 'test_helper'

class PeopleEditTest < ActionDispatch::IntegrationTest
  def setup
    @person = people :testable
  end

  test 'unsuccessful edit' do
    log_in_as @person
    get profile_edit_path
    assert_template 'people/edit'
    patch profile_edit_path, params: { person: { name: @person.name,
                                                 email: '',
                                                 password: '',
                                                 password_confirmation: '' } }
    assert_template 'people/edit'
  end

  test 'successfull edit' do
    log_in_as @person
    get profile_edit_path
    assert_template 'people/edit'
    name = 'New Name'
    email = 'new@mail.com'
    patch profile_edit_path, params: { person: { name: name,
                                                 email: email,
                                                 password: '',
                                                 password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to profile_path
    @person.reload
    assert_equal name, @person.name
    assert_equal email, @person.email
  end

  test 'successful edit with friendly forwarding' do
    get profile_edit_path
    log_in_as @person
    assert_redirected_to profile_edit_path
    name = 'New Name'
    email = 'new@mail.com'
    patch profile_edit_path, params: { person: { name: name,
                                                 email: email,
                                                 password: '',
                                                 password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to profile_path
    @person.reload
    assert_equal name, @person.name
    assert_equal email, @person.email
    assert_nil session[:forwarding_url]
  end
end
