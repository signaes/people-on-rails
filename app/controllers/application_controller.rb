class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery with: :exception

  include SessionsHelper

  def get_locale
    @locale = params[:locale] || I18n.default_locale
  end

  def set_locale
    unless @locale != I18n.default_locale
      if I18n.available_locales.map(&:to_s).include? @locale
        I18n.locale = @locale
      end
    end
  end

  def default_url_options
    return {} if I18n.locale == I18n.default_locale

    { locale: I18.locale }
  end
end
