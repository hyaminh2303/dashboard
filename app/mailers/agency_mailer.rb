class AgencyMailer < ActionMailer::Base
  default from: "#{ENV['SMTP_SENDER_NAME']} <#{ENV['SMTP_SENDER_EMAIL']}>"

  def invitation_email(agency, pwd)
    @agency = agency
    @pwd = pwd
    mail(to: @agency.email, subject: 'Welcome to Yoose')
  end

  def ready_for_finance_email(campaign)
    @campaign = campaign
    subject = "[Dashboard] Campaign #{@campaign.name} is ready for finance process"
    mail(to: ENV['FINANCE_USER_EMAIL'], subject: subject)
  end
end
