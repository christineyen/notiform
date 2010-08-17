class RecipientsController < ApplicationController
  def remind
    if recipient = Recipient.find_by_id(params[:id])
      recipient.remind_recipient

      respond_to do |format|
        format.json { render :json => {
            :html => render_to_string(:partial => 'remind') },
            :status => :ok }
      end
      return
    end
  end
end
