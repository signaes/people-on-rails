require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  def setup
    @person = Person.new name: 'Testable',
                         email: 'testable@mail.com'
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

  test 'email should be transformed to downcase before saving' do
    @person.email.upcase!
    @person.save
    assert_equal @person.email, @person.email.downcase
  end
end
