class PersonMailer < ApplicationMailer
  def account_activation(person)
    @person = person
    @greeting = 'Hi'

    mail to: person.email, subject: I18n.t('person_mailer.account_activation.subject')
  end

  def password_reset(person)
    @person = person
    @greeting = 'Hi'

    mail to: person.email, subject: I18n.t('person_mailer.password_reset.subject')
  end
end
