require 'test_helper'

class PeopleSignupTest < ActionDispatch::IntegrationTest
  test 'should not sign up without email' do
    get signup_path

    assert_no_difference 'Person.count' do
      post people_path, params: { person: { name: '',
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
      post people_path, params: { person: { name: 'Testable',
                                            email: 'testable@mail.com',
                                            password: '123456',
                                            password_confirmation: '123456' } }
    end

    follow_redirect!
    assert_template 'people/show'
    assert_not flash.empty?
  end
end
