require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  def setup
    @person = Person.new name: 'Testable',
                         email: 'testable@mail.com',
                         password: '123456',
                         password_confirmation: '123456'
  end

  test 'should be valid' do
    assert @person.valid?
  end

  test 'email should be present' do
    @person.email = ''
    assert_not @person.valid?
  end

  test 'name should not be too long' do
    @person.name = 'a' * 61
    assert_not @person.valid?
  end

  test 'email should not be too long' do
    @person.email = "#{'a' * 101}@mail.com"
    assert_not @person.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[person@mail.com PERSON@mail.com P_ers-on@mail.com.br
                         person.name@mail.kr person+name@mail.com]
    valid_addresses.each do |address|
      @person.email = address
      assert @person.valid?, "#{address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[person@mail,com person_at_mail.com person.name@mail.
                           person@mail_mail.com person@mail+mail.com]
    invalid_addresses.each do |address|
      @person.email = address
      assert_not @person.valid?, "#{address.inspect} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_person = @person.dup
    @person.save
    assert_not duplicate_person.valid?
  end

  test 'email addresses should be saved as lower case' do
    mixed_case_email = 'TeST@Mail.CoM'
    @person.email = mixed_case_email
    @person.save
    assert_equal mixed_case_email.downcase, @person.reload.email
  end

  test 'password should be present (nonblank)' do
    @person.password = @person.password_confirmation = ' ' * 6
    assert_not @person.valid?
  end

  test 'password should have a minimum length of 6 chars' do
    @person.password = @person.password_confirmation = 'a' * 5
    assert_not @person.valid?
  end
end
