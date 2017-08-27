require 'test_helper'

class LocalizationTest < ActionDispatch::IntegrationTest
  test 'get with locale' do
    get signup_path(locale: 'pt-BR')
    assert_select 'body' do |content|
      assert_match(/[S|s]enha/, content.to_s)
      assert_match(/[N|n]ome/, content.to_s)
    end

    # Clean up locale
    I18n.locale = I18n.default_locale
    get signup_path
    assert_select 'body' do |content|
      assert_match(/[P|p]assword/, content.to_s)
      assert_match(/[N|n]ame/, content.to_s)
    end
  end
end
