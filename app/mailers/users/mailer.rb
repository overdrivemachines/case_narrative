# frozen_string_literal: true

# Use the application mailer layout and the scoped users/mailer templates for
# every Devise notification. Declaring both formats keeps the handcrafted plain
# text alternatives alongside the Premailer-processed HTML messages.
class Users::Mailer < Devise::Mailer
  def confirmation_instructions(record, token, opts = {})
    @token = token
    devise_multipart_mail(record, :confirmation_instructions, opts)
  end

  def reset_password_instructions(record, token, opts = {})
    @token = token
    devise_multipart_mail(record, :reset_password_instructions, opts)
  end

  def unlock_instructions(record, token, opts = {})
    @token = token
    devise_multipart_mail(record, :unlock_instructions, opts)
  end

  def email_changed(record, opts = {})
    devise_multipart_mail(record, :email_changed, opts)
  end

  def password_change(record, opts = {})
    devise_multipart_mail(record, :password_change, opts)
  end

  private

  def devise_multipart_mail(record, action, opts)
    initialize_from_record(record)
    mail(headers_for(action, opts).merge(template_path: "users/mailer")) do |format|
      format.html
      format.text
    end
  end
end
