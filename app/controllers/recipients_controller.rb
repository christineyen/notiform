class RecipientsController < ApplicationController
  def remind
    if recipient = Recipient.find_by_id(params[:id])
      recipient.remind_recipient
      redirect_to :controller => 'wufoo_form', :action => 'report', :id => recipient.wufoo_form.id
    end
  end
end
