class RecipientMailer < ActionMailer::Base
  # to use a layout, make sure to use recipient_mailer.text.plain.erb

  # see http://guides.rubyonrails.org/action_mailer_basics.html
 
  def notify(recipient)
    recipients recipient.email
    from       "Notiform <notifications@christineyen.com>"
    subject    "NOTE: You've got a new form to fill out"
    sent_on    Time.now
    body       :token => recipient.token
  end

  def remind(recipient)
    recipients recipient.email
    from       "Notiform <notifications@christineyen.com>"
    subject    "REMINDER: You've got a form to fill out"
    sent_on    Time.now
    body       :token => recipient.token
  end  

end
