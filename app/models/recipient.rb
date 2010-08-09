class Recipient < ActiveRecord::Base
  belongs_to :wufoo_form
  before_create :generate_token
  after_create :notify_recipient
  attr_accessor :confirmed

  def remind_recipient
    puts "\nDELIVER REMINDER....\n\n"
    # RecipientMailer.deliver_remind(self)
    self.update_attribute(:last_reminded_at, Time.now)
  end

 private
  def generate_token
    self.token = rand(36**8).to_s(36) if self.new_record? and self.token.nil?
  end

  def notify_recipient(recipient)
    RecipientMailer.deliver_notify(recipient)
  end
end
