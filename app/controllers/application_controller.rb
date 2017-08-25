class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery with: :exception

  include SessionsHelper

  def locale
    @locale = params[:locale] || I18n.default_locale
  end

  def set_locale
    return if @locale == I18n.default_locale
    return unless locale_available?

    I18n.locale = @locale
  end

  def default_url_options
    return {} if I18n.locale == I18n.default_locale

    { locale: I18.locale }
  end

  private

  def available_locales
    I18n.available_locales.map(&:to_s)
  end

  def locale_available?
    available_locales.include? @locale
  end
end
