class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery with: :exception

  include SessionsHelper

  def set_locale
    find_locale
    return if @locale == I18n.default_locale
    return unless locale_available?

    I18n.locale = @locale
  end

  def default_url_options
    return {} if I18n.locale == I18n.default_locale

    { locale: I18n.locale }
  end

  private

  def find_locale
    @locale = params[:locale] ||
              extract_locale_from_accept_language_header ||
              I18n.default_locale
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE']
           .try(:scan, /^[a-z]{2}/)
           .try(:first)
  end

  def available_locales
    I18n.available_locales.map(&:to_s)
  end

  def locale_available?
    available_locales.include? @locale
  end
end
