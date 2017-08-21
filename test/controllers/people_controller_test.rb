require 'test_helper'

class PeopleControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get signup_path
    assert_response :success
  end
end
